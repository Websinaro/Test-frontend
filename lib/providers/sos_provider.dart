import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../models/sos_models.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/sos_socket_service.dart';

enum SosStatus { idle, sending, active, error }

class SosProvider extends ChangeNotifier {
  final ApiService _api = ApiService.instance;

  SosStatus status = SosStatus.idle;
  SosAlert? activeAlert;
  String? errorMessage;
  Timer? _locationTimer;
  StreamSubscription<Position>? _positionSub;
  SosSocketService? _socket;
  DateTime? _lastWsSendAt;

  /// Checks the server for an SOS the user already has active - e.g. the
  /// app was closed and reopened mid-emergency. Called once at startup so
  /// the button never wrongly resets to idle while a real SOS is still live.
  Future<void> restoreActiveSos() async {
    try {
      final alert = await _api.fetchMyActiveSos();
      if (alert != null && alert.isActive) {
        activeAlert = alert;
        status = SosStatus.active;
        notifyListeners();
        _startLocationUpdates();
      }
    } catch (_) {
      // Non-fatal - if this check fails (offline, server waking up), just
      // leave the button in its default state rather than blocking startup.
    }
  }

  Future<bool> sendSos() async {
    status = SosStatus.sending;
    errorMessage = null;
    notifyListeners();

    try {
      final position = await LocationService.instance.getAccuratePosition();
      final alert = await _api.createSos(
        lat: position.latitude,
        lon: position.longitude,
        message: 'Emergency SOS triggered from the WeBAlert app.',
      );

      activeAlert = alert;
      status = SosStatus.active;
      notifyListeners();

      _startLocationUpdates();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = SosStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Could not get your location. Please enable location and try again.';
      status = SosStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Streams location out two ways at once, tuned for a disaster area's
  /// weak/patchy connectivity:
  ///  - A live WebSocket carries every GPS fix the moment it's available
  ///    (throttled to at most one every 3s so a burst of GPS updates
  ///    doesn't flood a slow link) - this is what makes the rescuer's map
  ///    feel "live" instead of updating every 15s.
  ///  - The original REST PATCH keeps running on its own slower timer
  ///    regardless of whether the socket is currently connected. If the
  ///    WebSocket can't get through (carrier-grade NAT killed it, signal
  ///    dropped entirely), this is what keeps the last-known location on
  ///    the server from going stale for more than ~15s.
  void _startLocationUpdates() {
    _locationTimer?.cancel();
    _positionSub?.cancel();
    _socket?.dispose();

    final alert = activeAlert;
    if (alert == null) return;

    _socket = SosSocketService(sosId: alert.id)..connect();

    _positionSub = LocationService.instance.watchPosition().listen((position) {
      final now = DateTime.now();
      if (_lastWsSendAt != null && now.difference(_lastWsSendAt!) < const Duration(seconds: 3)) {
        return;
      }
      _lastWsSendAt = now;
      _socket?.sendLocation(
        lat: position.latitude,
        lon: position.longitude,
        accuracyM: position.accuracy,
        speedMps: position.speed,
        headingDeg: position.heading,
      );
    }, onError: (_) {});

    _locationTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      final current = activeAlert;
      if (current == null || !current.isActive) {
        _locationTimer?.cancel();
        return;
      }
      try {
        final position = await LocationService.instance.getAccuratePosition();
        await _api.updateSosLocation(sosId: current.id, lat: position.latitude, lon: position.longitude);
      } catch (_) {
        // Skip this tick silently - a single missed update isn't worth
        // interrupting an active emergency with an error dialog. The
        // WebSocket path above is likely still getting fixes through even
        // when a single REST call times out.
      }
    });
  }

  Future<bool> markSafe() async {
    final alert = activeAlert;
    if (alert == null) return true;

    try {
      await _api.resolveSos(alert.id);
      _stopLocationUpdates();
      status = SosStatus.idle;
      activeAlert = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  void _stopLocationUpdates() {
    _locationTimer?.cancel();
    _positionSub?.cancel();
    _socket?.dispose();
    _socket = null;
  }

  void resetError() {
    if (status == SosStatus.error) {
      status = SosStatus.idle;
      errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stopLocationUpdates();
    super.dispose();
  }
}
