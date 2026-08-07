import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'location_service.dart';

/// A road route between the rescuer and the person in distress: the
/// polyline to draw on the SOS live map plus the remaining distance/ETA
/// to show in the info card.
class RouteResult {
  final List<LatLng> path;
  final double distanceMeters;
  final Duration duration;

  /// True when [path]/[duration] are a real road route from the routing
  /// API. False means we fell back to a straight line + straight-line
  /// distance (e.g. no network) - the UI should label that difference
  /// ("direct distance" instead of "by road") rather than imply an ETA
  /// it can't back up.
  final bool isRoadRoute;

  const RouteResult({
    required this.path,
    required this.distanceMeters,
    required this.duration,
    required this.isRoadRoute,
  });

  double get distanceKm => distanceMeters / 1000;
}

/// Fetches a driving route between two points from OSRM's free public
/// routing API (no key required) for the SOS live map, so the rescuer sees
/// an actual road path and ETA rather than just a straight line.
class RoutingService {
  RoutingService._internal();
  static final RoutingService instance = RoutingService._internal();

  static const String _baseUrl = 'https://router.project-osrm.org/route/v1/driving';
  static const Duration _timeout = Duration(seconds: 8);

  final http.Client _client = http.Client();

  Future<RouteResult> getRoute({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/$startLon,$startLat;$endLon,$endLat?overview=full&geometries=polyline',
      );
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        throw Exception('routing failed: ${response.statusCode}');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = body['routes'] as List?;
      if (routes == null || routes.isEmpty) {
        throw Exception('no route found');
      }

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as String;
      final distanceMeters = (route['distance'] as num).toDouble();
      final durationSeconds = (route['duration'] as num).toDouble();

      return RouteResult(
        path: _decodePolyline(geometry),
        distanceMeters: distanceMeters,
        duration: Duration(seconds: durationSeconds.round()),
        isRoadRoute: true,
      );
    } catch (_) {
      // Offline, timed out, or the routing service is unreachable - still
      // give the rescuer something useful: a straight line and the
      // straight-line distance, just labeled honestly as such by the UI.
      final straightMeters = LocationService.instance.distanceBetween(startLat, startLon, endLat, endLon);
      return RouteResult(
        path: [LatLng(startLat, startLon), LatLng(endLat, endLon)],
        distanceMeters: straightMeters,
        duration: Duration.zero,
        isRoadRoute: false,
      );
    }
  }

  /// Decodes a Google-encoded polyline (the format OSRM returns) into a
  /// list of coordinates. Standard algorithm - precision 5 (OSRM default).
  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lon = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final deltaLon = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lon += deltaLon;

      points.add(LatLng(lat / 1e5, lon / 1e5));
    }

    return points;
  }
}
