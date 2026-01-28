import 'dart:math';

double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
    ) {
  const earthRadius = 6371;
  final dLat = _deg(lat2 - lat1);
  final dLon = _deg(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg(lat1)) *
          cos(_deg(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  return earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a));
}

double _deg(double d) => d * pi / 180;
