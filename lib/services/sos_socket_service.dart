import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'api_service.dart';

/// A single event coming off the SOS live-location socket. `type` is either
/// "location" (a new GPS fix from the person who triggered the SOS) or
/// "resolved" (they've been marked safe).
class SosSocketEvent {
  final String type;
  final double? latitude;
  final double? longitude;
  final double? accuracyM;
  final double? speedMps;
  final double? headingDeg;
  final String? timestamp;

  SosSocketEvent._({
    required this.type,
    this.latitude,
    this.longitude,
    this.accuracyM,
    this.speedMps,
    this.headingDeg,
    this.timestamp,
  });

  factory SosSocketEvent.fromJson(Map<String, dynamic> json) {
    double? n(dynamic v) => (v as num?)?.toDouble();
    return SosSocketEvent._(
      type: (json['type'] ?? '').toString(),
      latitude: n(json['latitude']),
      longitude: n(json['longitude']),
      accuracyM: n(json['accuracy_m']),
      speedMps: n(json['speed_mps']),
      headingDeg: n(json['heading_deg']),
      timestamp: json['ts']?.toString(),
    );
  }
}

/// Manages one WebSocket connection to `/ws/sos/{id}` for the live SOS
/// location feed - used both by the person sending the SOS (to stream GPS
/// fixes out) and by a protector's live map screen (to receive them).
///
/// Built specifically for disaster-area conditions: a single persistent
/// TCP connection avoids the repeated HTTP handshake/TLS-negotiation
/// overhead of polling, which matters a lot on 2G/3G. Reconnection uses
/// capped exponential backoff so a flaky link keeps retrying without
/// hammering the network, and every caller is expected to keep the REST
/// fallback (SosProvider's periodic PATCH, the live map's slower REST poll)
/// running alongside this - if the socket can't get through, the app still
/// works, just less instantly.
class SosSocketService {
  SosSocketService({required this.sosId});

  final int sosId;

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _reconnectTimer;
  bool _disposed = false;
  int _backoffStep = 0;

  final _eventsController = StreamController<SosSocketEvent>.broadcast();

  /// Fires for every "location" and "resolved" event received. Broadcast
  /// so both a provider and a screen can listen at the same time if needed.
  Stream<SosSocketEvent> get events => _eventsController.stream;

  bool _connected = false;
  bool get isConnected => _connected;

  static const List<Duration> _backoffSchedule = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
    Duration(seconds: 15), // cap - keep retrying every 15s indefinitely
  ];

  Future<void> connect() async {
    if (_disposed) return;
    try {
      final uri = await ApiService.instance.sosWebSocketUri(sosId);
      // IOWebSocketChannel (not the generic WebSocketChannel.connect) so
      // this works the same on every non-web platform this app ships to,
      // with an explicit connect timeout tuned for a slow mobile link
      // rather than the platform default.
      final channel = IOWebSocketChannel.connect(
        uri,
        connectTimeout: const Duration(seconds: 15),
        pingInterval: const Duration(seconds: 20),
      );
      _channel = channel;

      _sub = channel.stream.listen(
        _onData,
        onError: (_) => _scheduleReconnect(),
        onDone: _scheduleReconnect,
        cancelOnError: true,
      );

      // Wait for the underlying connection to actually establish before
      // declaring success, so callers relying on isConnected right after
      // connect() aren't misled by a socket that's still handshaking.
      await channel.ready;
      _connected = true;
      _backoffStep = 0;
    } catch (_) {
      _connected = false;
      _scheduleReconnect();
    }
  }

  void _onData(dynamic raw) {
    try {
      final json = jsonDecode(raw is String ? raw : utf8.decode(raw as List<int>)) as Map<String, dynamic>;
      _eventsController.add(SosSocketEvent.fromJson(json));
    } catch (_) {
      // Malformed frame - ignore rather than tear down the whole socket.
    }
  }

  /// Sends a GPS fix. Silently drops it if the socket isn't connected right
  /// now - callers (SosProvider) are expected to also be pushing REST
  /// updates on a slower cadence as a safety net, so a dropped WS frame
  /// here never means a location update is lost entirely.
  void sendLocation({
    required double lat,
    required double lon,
    double? accuracyM,
    double? speedMps,
    double? headingDeg,
  }) {
    if (!_connected || _channel == null) return;
    try {
      _channel!.sink.add(jsonEncode({
        'latitude': lat,
        'longitude': lon,
        'accuracy_m': accuracyM ?? 0,
        'speed_mps': speedMps ?? 0,
        'heading_deg': headingDeg ?? 0,
      }));
    } catch (_) {
      // Socket died between the isConnected check and this write - the
      // stream's onError/onDone will fire and trigger reconnect.
    }
  }

  void _scheduleReconnect() {
    _connected = false;
    _sub?.cancel();
    _sub = null;
    _channel = null;

    if (_disposed) return;

    final delay = _backoffSchedule[_backoffStep.clamp(0, _backoffSchedule.length - 1)];
    if (_backoffStep < _backoffSchedule.length - 1) _backoffStep++;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  Future<void> disconnect() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    await _sub?.cancel();
    try {
      await _channel?.sink.close(ws_status.normalClosure);
    } catch (_) {}
    _connected = false;
  }

  void dispose() {
    disconnect();
    _eventsController.close();
  }
}
