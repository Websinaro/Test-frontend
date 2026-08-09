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

  /// Public entry point that dispatches ANY supported alert type (SOS,
  /// admin/president broadcast, and future types) to its handler. The
  /// top-level background handler in main.dart must use this - not
  /// showSosNotification - so alerts other than SOS still display when
  /// the app is backgrounded or fully terminated. Also (re)initializes
  /// the local-notifications plugin, since a background message runs in
  /// its own fresh isolate that never ran initialize().
  Future<void> showAnyNotification(RemoteMessage message) async {
    await _ensureLocalNotificationsInitialized();
    await _showAnyNotification(message);
  }

  bool _localInitialized = false;

  Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localInitialized) return;
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) => _handlePayload(response.payload),
    );
    _localInitialized = true;
  }

  Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

    // Re-create the channel every launch - cheap, and picks up DND-bypass
    // status immediately once the user grants Notification Policy Access
    // (they might grant it after first install, on a later app open).
    await DndService.instance.createSosChannel();

    await _ensureLocalNotificationsInitialized();

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
      // Explicit (matches the plugin's own default, but stated here on
      // purpose): every _local.show() call for this channel must alert
      // again - sound, heads-up, everything - rather than silently
      // updating an existing notification in place. That silent-update
      // behavior is exactly what made a second real SOS to an already-
      // notified phone look like "notifications stopped working".
      onlyAlertOnce: false,
    );

    await _local.show(
      _sosNotificationId(message.data['sos_id']),
      'EMERGENCY: $senderName needs help',
      'Tap to see their live location',
      const NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }

  /// A stable, collision-resistant notification ID for a given SOS alert.
  /// Parses the numeric sos_id directly rather than hashing the string, so
  /// two different alerts can never coincidentally land on the same
  /// Android notification ID and silently clobber each other.
  int _sosNotificationId(dynamic sosId) {
    final parsed = int.tryParse('$sosId');
    // Notification IDs are 32-bit ints on Android; keep it in range while
    // still being effectively unique per alert.
    return parsed != null ? (parsed & 0x7FFFFFFF) : '$sosId'.hashCode;
  }

  /// Cancels the ongoing SOS notification for an alert that's just been
  /// marked safe. Without this, the non-dismissible ("ongoing") emergency
  /// notification stays in the tray forever - and on several Android
  /// builds, a *new* full-screen-intent notification gets suppressed while
  /// an old one from the same app is still showing. Clearing it the moment
  /// the alert resolves is what keeps the next real SOS from silently
  /// failing to alert on this device.
  Future<void> _cancelSosNotification(dynamic sosId) async {
    await _ensureLocalNotificationsInitialized();
    await _local.cancel(_sosNotificationId(sosId));
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
      case 'sos_resolved':
        await _cancelSosNotification(message.data['sos_id']);
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
