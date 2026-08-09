import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

import '../../localization/app_language.dart';
import '../../localization/app_strings.dart';
import '../../models/sos_models.dart';
import '../../providers/language_provider.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';
import '../../services/routing_service.dart';
import '../../services/sos_socket_service.dart';
import '../../theme/app_colors.dart';

/// Live map shown to a rescuer (protector) after tapping an SOS
/// notification: the emergency person's location, the rescuer's own live
/// location, the road path between them, and the remaining distance/ETA -
/// all updating in real time until the SOS is resolved.
class SosLiveMapScreen extends StatefulWidget {
  final int sosId;
  final String senderName;
  final double initialLat;
  final double initialLon;

  const SosLiveMapScreen({
    super.key,
    required this.sosId,
    required this.senderName,
    required this.initialLat,
    required this.initialLon,
  });

  @override
  State<SosLiveMapScreen> createState() => _SosLiveMapScreenState();
}

class _SosLiveMapScreenState extends State<SosLiveMapScreen> {
  late SosAlert? _alert;
  Timer? _emgPoller;
  StreamSubscription<Position>? _mySub;
  final MapController _mapController = MapController();

  // Live WebSocket feed of the emergency person's location - the fast path.
  // The REST poller above stays running too, just on a much slower cadence,
  // purely as a safety net for when the socket can't get through at all.
  SosSocketService? _socket;
  StreamSubscription<SosSocketEvent>? _socketSub;
  LatLng? _emgLiveLocation;
  bool _resolvedViaSocket = false;

  LatLng? _myLocation;
  RouteResult? _route;
  bool _fetchingRoute = false;
  bool _hasFramedInitialView = false;
  String? _locationError;

  // Rolling average of the rescuer's own GPS speed (m/s), used to estimate
  // an ETA when the road-routing API is unreachable - a real possibility
  // in a disaster area where general internet is weak/blocked but the
  // app's own lightweight WebSocket to its own backend still gets through.
  final List<double> _recentSpeeds = [];

  @override
  void initState() {
    super.initState();
    _alert = null;
    _fetchEmgLocation();
    // Slow REST fallback poll - the WebSocket below is the primary,
    // near-instant path. This just guards against the socket silently
    // failing to connect on a very poor link.
    _emgPoller = Timer.periodic(const Duration(seconds: 20), (_) => _fetchEmgLocation());
    _startWatchingMyLocation();
    _connectLiveSocket();
  }

  Future<void> _connectLiveSocket() async {
    final socket = SosSocketService(sosId: widget.sosId);
    _socket = socket;
    _socketSub = socket.events.listen(_onSocketEvent);
    await socket.connect();
  }

  void _onSocketEvent(SosSocketEvent event) {
    if (!mounted) return;
    if (event.type == 'location' && event.latitude != null && event.longitude != null) {
      setState(() => _emgLiveLocation = LatLng(event.latitude!, event.longitude!));
      _refreshRoute();
      _fitBoundsOnce();
    } else if (event.type == 'resolved') {
      setState(() => _resolvedViaSocket = true);
      _emgPoller?.cancel();
    }
  }

  Future<void> _startWatchingMyLocation() async {
    try {
      final current = await LocationService.instance.getAccuratePosition();
      _onMyPosition(current);
    } catch (e) {
      if (mounted) setState(() => _locationError = e.toString());
    }

    _mySub = LocationService.instance.watchPosition().listen(
      _onMyPosition,
      onError: (_) {}, // keep showing the last known fix if the stream hiccups
    );
  }

  void _onMyPosition(Position position) {
    if (!mounted) return;
    setState(() {
      _myLocation = LatLng(position.latitude, position.longitude);
      _locationError = null;
    });
    if (position.speed.isFinite && position.speed > 0) {
      _recentSpeeds.add(position.speed);
      if (_recentSpeeds.length > 8) _recentSpeeds.removeAt(0);
    }
    _refreshRoute();
    _fitBoundsOnce();
  }

  /// Average of the rescuer's last few GPS speed samples (m/s), or null if
  /// there aren't enough recent samples to trust yet.
  double? get _averageSpeedMps {
    if (_recentSpeeds.length < 2) return null;
    final avg = _recentSpeeds.reduce((a, b) => a + b) / _recentSpeeds.length;
    return avg > 0.3 ? avg : null; // ignore near-zero noise while stationary
  }

  Future<void> _fetchEmgLocation() async {
    try {
      final alert = await ApiService.instance.fetchSos(widget.sosId);
      if (!mounted) return;
      setState(() => _alert = alert);
      _refreshRoute();
      _fitBoundsOnce();
      if (!alert.isActive) {
        _emgPoller?.cancel();
      }
    } catch (_) {
      // Skip this tick - keep showing the last known position.
    }
  }

  /// The freshest known location of the person in distress: the WebSocket
  /// feed if it's delivered anything yet (near-instant), falling back to
  /// the last REST fetch, then the coordinates the notification arrived
  /// with.
  LatLng _currentEmgLocation() {
    if (_emgLiveLocation != null) return _emgLiveLocation!;
    if (_alert != null) return LatLng(_alert!.latitude, _alert!.longitude);
    return LatLng(widget.initialLat, widget.initialLon);
  }

  /// Re-fetches the road path + remaining distance whenever either point
  /// moves. Guarded by _fetchingRoute so a slow response doesn't stack up
  /// requests behind a burst of GPS updates.
  Future<void> _refreshRoute() async {
    final me = _myLocation;
    if (me == null || _fetchingRoute) return;
    if (_alert == null && _emgLiveLocation == null) return;

    final emg = _currentEmgLocation();
    _fetchingRoute = true;
    try {
      final result = await RoutingService.instance.getRoute(
        startLat: me.latitude,
        startLon: me.longitude,
        endLat: emg.latitude,
        endLon: emg.longitude,
      );
      if (!mounted) return;
      setState(() => _route = result);
    } finally {
      _fetchingRoute = false;
    }
  }

  /// Frames the map to show both the rescuer and the EMG person the first
  /// time both locations are known. After that we leave the camera alone
  /// so the rescuer can freely pan/zoom without it fighting them.
  void _fitBoundsOnce() {
    if (_hasFramedInitialView) return;
    final me = _myLocation;
    if (me == null) return;
    if (_alert == null && _emgLiveLocation == null) return;

    _hasFramedInitialView = true;
    final bounds = LatLngBounds.fromPoints([me, _currentEmgLocation()]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.fromLTRB(60, 120, 60, 220)),
      );
    });
  }

  @override
  void dispose() {
    _emgPoller?.cancel();
    _mySub?.cancel();
    _socketSub?.cancel();
    _socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final emgLocation = _currentEmgLocation();
    final emgLat = emgLocation.latitude;
    final emgLon = emgLocation.longitude;
    final isActive = _resolvedViaSocket ? false : (_alert?.isActive ?? true);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.alertDarkRed,
        title: Text('${widget.senderName} - ${isActive ? AppStrings.t('sos_active_appbar', lang) : AppStrings.t('resolved', lang)}'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: LatLng(emgLat, emgLon), initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.websinaro.webalert',
              ),
              if (_route != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _route!.path,
                      strokeWidth: _route!.isRoadRoute ? 5 : 3,
                      // Full opacity for a real road route; faded when it's
                      // just the straight-line fallback (no routing data),
                      // so the rescuer can tell the difference at a glance.
                      color: _route!.isRoadRoute
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  // The emergency person - stays put, prominent red pin.
                  Marker(
                    point: LatLng(emgLat, emgLon),
                    width: 60,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.alertDarkRed,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: AppColors.alertDarkRed.withValues(alpha: 0.6), blurRadius: 12)],
                      ),
                      child: const Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 34),
                    ),
                  ),
                  // The rescuer (you) - live-updating blue dot.
                  if (_myLocation != null)
                    Marker(
                      point: _myLocation!,
                      width: 46,
                      height: 46,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.6), blurRadius: 10)],
                        ),
                        child: const Icon(Icons.navigation_rounded, color: Colors.black, size: 22),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (!isActive)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.alertGreen, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  AppStrings.t('marked_safe_banner', lang),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (_locationError != null && _myLocation == null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.alertOrange, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${AppStrings.t('enable_location_prefix', lang)} $_locationError',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _DistanceCard(
              route: _route,
              hasMyLocation: _myLocation != null,
              lang: lang,
              fallbackSpeedMps: _averageSpeedMps,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom info card showing the live remaining distance and ETA (or a
/// "direct distance" label when no road route could be fetched).
class _DistanceCard extends StatelessWidget {
  final RouteResult? route;
  final bool hasMyLocation;
  final AppLanguage lang;

  /// The rescuer's own recent average GPS speed (m/s), used to estimate an
  /// ETA when [route] fell back to a straight line because the road-routing
  /// API couldn't be reached - a real scenario in a disaster area where
  /// general internet is weak but this app's own lightweight backend
  /// connection still gets through.
  final double? fallbackSpeedMps;

  const _DistanceCard({
    required this.route,
    required this.hasMyLocation,
    required this.lang,
    this.fallbackSpeedMps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.directions_run_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(child: _buildText(context)),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    if (!hasMyLocation) {
      return Text(
        AppStrings.t('locating_you', lang),
        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
      );
    }
    if (route == null) {
      return Text(
        AppStrings.t('calculating_route', lang),
        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
      );
    }

    final r = route!;
    final distanceText = r.distanceMeters < 1000
        ? '${r.distanceMeters.round()} m'
        : '${(r.distanceMeters / 1000).toStringAsFixed(1)} km';

    // Prefer the real road-route ETA. If we only have a straight-line
    // fallback (routing API unreachable) but the rescuer is clearly moving,
    // estimate an ETA from their own recent speed instead of showing
    // nothing - clearly labeled as an estimate, not a road ETA.
    String? etaText;
    bool etaIsEstimate = false;
    if (r.isRoadRoute && r.duration.inSeconds > 0) {
      etaText = _formatDuration(r.duration);
    } else if (fallbackSpeedMps != null && fallbackSpeedMps! > 0.3) {
      final seconds = r.distanceMeters / fallbackSpeedMps!;
      etaText = _formatDuration(Duration(seconds: seconds.round()));
      etaIsEstimate = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              distanceText,
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 20),
            ),
            if (etaText != null) ...[
              const SizedBox(width: 10),
              Text(
                '\u2022 ~$etaText${etaIsEstimate ? '*' : ''}',
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          r.isRoadRoute
              ? AppStrings.t('remaining_distance_road', lang)
              : etaIsEstimate
                  ? '${AppStrings.t('direct_distance', lang)} \u2022 *ETA estimated from your current speed'
                  : AppStrings.t('direct_distance', lang),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    if (d.inMinutes < 1) return '<1 min';
    if (d.inMinutes < 60) return '${d.inMinutes} min';
    final hours = d.inMinutes ~/ 60;
    final mins = d.inMinutes % 60;
    return '${hours}h ${mins}m';
  }
}
