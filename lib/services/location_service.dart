import 'package:geolocator/geolocator.dart';

class LocationException implements Exception {
  final String message;
  final bool permanentlyDenied;
  LocationException(this.message, {this.permanentlyDenied = false});

  @override
  String toString() => message;
}

class LocationService {
  LocationService._internal();
  static final LocationService instance = LocationService._internal();

  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() => Geolocator.requestPermission();

  /// Requests permission and returns the current device position.
  /// Throws [LocationException] with a user-friendly message on failure.
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location services are turned off. Please enable GPS to see local weather.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permission was denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Location permission is permanently denied. Enable it from the app settings.',
        permanentlyDenied: true,
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 100,
      ),
    );
  }

  /// Continuous stream of the device's position, used for the rescuer's
  /// live "blue dot" on the SOS map. Tighter accuracy and a small distance
  /// filter (5m) than getCurrentPosition() - this drives a live-updating
  /// route/distance so it needs to react promptly as the rescuer moves.
  /// Assumes permission has already been granted (call getCurrentPosition()
  /// or checkPermission()/requestPermission() first).
  Stream<Position> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }

  /// Straight-line distance in meters between two coordinates. Used as an
  /// instant fallback whenever the road-routing API is unavailable.
  double distanceBetween(double startLat, double startLon, double endLat, double endLon) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  }
}
