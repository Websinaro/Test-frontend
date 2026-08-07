import 'package:flutter/foundation.dart';

import '../models/notification_item.dart';
import '../services/api_service.dart';

enum NotificationLoadState { idle, loading, loaded, error }

/// Backs both the citizen's read-only alert inbox and the president's
/// Notification Center (create/update/delete). Which one a screen gets
/// depends only on which methods it calls - the backend already scopes
/// [refresh] correctly per-role (president sees everything they've sent,
/// citizens see active alerts for their district + statewide ones).
class NotificationProvider extends ChangeNotifier {
  final ApiService _api = ApiService.instance;

  NotificationLoadState state = NotificationLoadState.idle;
  List<NotificationItem> notifications = [];
  String? errorMessage;
  bool _submitting = false;
  bool get submitting => _submitting;

  Future<void> refresh() async {
    state = NotificationLoadState.loading;
    notifyListeners();
    try {
      notifications = await _api.fetchNotifications();
      state = NotificationLoadState.loaded;
      errorMessage = null;
    } on ApiException catch (e) {
      errorMessage = e.message;
      state = NotificationLoadState.error;
    } catch (_) {
      errorMessage = 'Could not load alerts. Pull down to retry.';
      state = NotificationLoadState.error;
    }
    notifyListeners();
  }

  Future<void> create({
    required String title,
    required String message,
    required String severity,
    String? district,
  }) async {
    _submitting = true;
    notifyListeners();
    try {
      final created = await _api.createNotification(
        title: title,
        message: message,
        severity: severity,
        district: district,
      );
      notifications = [created, ...notifications];
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  Future<void> update({
    required int id,
    String? title,
    String? message,
    String? severity,
    String? district,
    bool clearDistrict = false,
    bool? active,
  }) async {
    _submitting = true;
    notifyListeners();
    try {
      final updated = await _api.updateNotification(
        id: id,
        title: title,
        message: message,
        severity: severity,
        district: district,
        clearDistrict: clearDistrict,
        active: active,
      );
      notifications = [
        for (final n in notifications) if (n.id == id) updated else n,
      ];
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    final previous = notifications;
    notifications = notifications.where((n) => n.id != id).toList();
    notifyListeners();
    try {
      await _api.deleteNotification(id);
    } catch (e) {
      // Roll back the optimistic removal if the delete actually failed.
      notifications = previous;
      notifyListeners();
      rethrow;
    }
  }

  void reset() {
    state = NotificationLoadState.idle;
    notifications = [];
    errorMessage = null;
    notifyListeners();
  }
}
