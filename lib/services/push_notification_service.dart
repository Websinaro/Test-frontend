import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'api_service.dart';
import 'dnd_service.dart';

/// Handles FCM setup, the custom high-priority SOS notification channel,
/// and routing a tapped notification to the live SOS map screen.
///
/// `onSosNotificationTapped` is set by the app's navigation layer (main.dart
/// or wherever the navigatorKey lives) so this service stays UI-agnostic.
class PushNotificationService {
  PushNotificationService._internal();
  static final PushNotificationService instance = PushNotificationService._internal();

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  void Function(int sosId, String senderName, double lat, double lon)? onSosNotificationTapped;

  /// Fired when the user taps a president/admin broadcast alert
  /// notification. Args: (notificationId, title).
  void Function(int notificationId, String title)? onAdminAlertTapped;

  /// Public so the top-level background handler in main.dart can reuse the
  /// exact same notification logic as the foreground listener.
  Future<void> showSosNotification(RemoteMessage message) => _showSosNotification(message);
  
  Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

    // Re-create the channel every launch - cheap, and picks up DND-bypass
    // status immediately once the user grants Notification Policy Access
    // (they might grant it after first install, on a later app open).
    await DndService.instance.createSosChannel();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) => _handlePayload(response.payload),
    );

    // Foreground: FCM doesn't auto-show a system notification while the app
    // is open, so we display it ourselves via flutter_local_notifications
    // using the same high-priority channel.
    FirebaseMessaging.onMessage.listen(_showAnyNotification);

    // Tapped from background (app was minimized).
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleDataPayload(message.data);
    });

    // App was fully terminated and opened via the notification tap.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleDataPayload(initialMessage.data);
    }

    // Register/refresh this device's token with the backend so protectors
    // can actually be reached. At a cold start this normally runs before
    // the user is logged in (see registerCurrentToken() below for why that
    // matters), so it's expected to no-op here on a fresh install.
    await registerCurrentToken();
    FirebaseMessaging.instance.onTokenRefresh.listen(_registerToken);
  }

  /// Fetches the current FCM token and (re)registers it with the backend.
  ///
  /// Public and safe to call any time we know we have a valid auth token -
  /// specifically right after a successful login and after a successful
  /// session restore - not just from initialize(). initialize() runs at
  /// app startup before the user has necessarily logged in, so
  /// registerDeviceToken() fails there (no auth token yet) and, since that
  /// failure is swallowed as non-fatal, nothing retried it. In practice
  /// that meant a freshly-logged-in user's device was never registered as
  /// a protector for the rest of that session - any SOS sent to them
  /// silently failed to deliver until they force-closed and reopened the
  /// app. Calling this again right after login/restoreSession closes that
  /// gap.
  Future<void> registerCurrentToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _registerToken(token);
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await ApiService.instance.registerDeviceToken(token: token, platform: 'android');
    } catch (_) {
      // Non-fatal - will retry on next app open / token refresh / explicit
      // registerCurrentToken() call (e.g. right after login).
    }
  }

  Future<void> _showSosNotification(RemoteMessage message) async {
    if (message.data['type'] != 'sos_alert') return;

    final senderName = message.data['sender_name'] ?? 'Someone';
    final payload = jsonEncode(message.data);

    const androidDetails = AndroidNotificationDetails(
      'sos_alerts',
      'SOS Emergency Alerts',
      channelDescription: 'Emergency alerts from your Safety Circle',
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.call,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('sos_alarm'),
      visibility: NotificationVisibility.public,
    );

    await _local.show(
      message.data['sos_id']?.hashCode ?? 0,
      'EMERGENCY: $senderName needs help',
      'Tap to see their live location',
      const NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  /// Dispatches to the right handler based on `data.type` - kept as one
  /// entry point for FirebaseMessaging.onMessage so foreground SOS alerts
  /// and foreground admin/president alerts both get displayed the same
  /// way background ones do.
  Future<void> _showAnyNotification(RemoteMessage message) async {
    switch (message.data['type']) {
      case 'sos_alert':
        await _showSosNotification(message);
        break;
      case 'admin_alert':
        await _showAdminAlertNotification(message);
        break;
    }
  }

  /// A president/state-coordinator broadcast alert (state-wide or targeted
  /// at the recipient's district). Uses its own channel - high priority,
  /// but not the full-screen/ongoing SOS treatment, since this isn't a
  /// personal emergency, it's an official advisory.
  Future<void> _showAdminAlertNotification(RemoteMessage message) async {
    final title = (message.data['title'] ?? 'Official Alert').toString();
    final body = (message.data['body'] ?? '').toString();
    final severity = (message.data['severity'] ?? 'orange').toString();
    final payload = jsonEncode(message.data);

    final importance = (severity == 'dark_red' || severity == 'light_red') ? Importance.max : Importance.high;

    final androidDetails = AndroidNotificationDetails(
      'admin_alerts',
      'Official State Alerts',
      channelDescription: 'Alerts issued by the President / State Coordinator',
      importance: importance,
      priority: importance == Importance.max ? Priority.max : Priority.high,
      playSound: true,
      visibility: NotificationVisibility.public,
    );

    await _local.show(
      message.data['notification_id']?.hashCode ?? title.hashCode,
      title,
      body,
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  void _handlePayload(String? payload) {
    if (payload == null) return;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _handleDataPayload(data);
    } catch (_) {}
  }

  void _handleDataPayload(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'sos_alert':
        final sosId = int.tryParse('${data['sos_id']}');
        final lat = double.tryParse('${data['latitude']}');
        final lon = double.tryParse('${data['longitude']}');
        if (sosId == null || lat == null || lon == null) return;
        onSosNotificationTapped?.call(sosId, data['sender_name']?.toString() ?? 'Someone', lat, lon);
        break;
      case 'admin_alert':
        final notificationId = int.tryParse('${data['notification_id']}') ?? 0;
        onAdminAlertTapped?.call(notificationId, (data['title'] ?? 'Official Alert').toString());
        break;
    }
  }
}
