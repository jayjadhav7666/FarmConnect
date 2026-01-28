import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:farmconnect/core/constants/app_constants.dart';

class LocationUtils {
  static Future<double?> calculateDistanceFromAddress({
    required String address,
  }) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations.first;

        double distanceInMeters = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          AppConstants.marketLat,
          AppConstants.marketLng,
        );

        return double.parse((distanceInMeters / 1000).toStringAsFixed(2));
      }
    } catch (e) {
      // Re-throw or handle error as needed
      rethrow;
    }
    return null;
  }
}
