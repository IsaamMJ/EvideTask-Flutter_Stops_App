// lib/domain/entities/stop.dart
import 'dart:math';

class Stop {
  final int id;
  final String name;
  final String description;
  final double lat;
  final double lng;
  final bool isFavorite;

  const Stop({
    required this.id,
    required this.name,
    required this.description,
    required this.lat,
    required this.lng,
    this.isFavorite = false,
  });

  Stop copyWith({bool? isFavorite}) {
    return Stop(
      id: id,
      name: name,
      description: description,
      lat: lat,
      lng: lng,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Get estimated arrival time based on a simple formula
  /// This is a placeholder implementation for the MVP
  String get estimatedArrival {
    // Simple ETA calculation based on stop characteristics
    final baseTime = 5; // Base 5 minutes
    final variableTime = (id % 12) + 1; // 1-12 additional minutes based on ID
    final totalMinutes = baseTime + variableTime;

    return "${totalMinutes} min";
  }

  /// Calculate distance from current location (in km)
  double distanceFromLocation(double currentLat, double currentLng) {
    return _calculateHaversineDistance(currentLat, currentLng, lat, lng);
  }

  /// Get more realistic ETA based on distance from current location
  String getRealisticEta(double currentLat, double currentLng) {
    final distanceKm = distanceFromLocation(currentLat, currentLng);

    // Assume average speed of 25 km/h in city traffic
    const averageSpeedKmh = 25.0;
    final etaHours = distanceKm / averageSpeedKmh;
    final etaMinutes = (etaHours * 60).round();

    if (etaMinutes < 1) {
      return "< 1 min";
    } else if (etaMinutes > 60) {
      final hours = etaMinutes ~/ 60;
      final minutes = etaMinutes % 60;
      return "${hours}h ${minutes}m";
    } else {
      return "${etaMinutes} min";
    }
  }

  /// Calculate distance using Haversine formula
  double _calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * asin(sqrt(a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// Get a short version of description for list display
  String get shortDescription {
    if (description.length <= 30) return description;
    return '${description.substring(0, 27)}...';
  }

  /// Get stop type based on name/description (for UI icons)
  StopType get stopType {
    final nameDesc = '${name.toLowerCase()} ${description.toLowerCase()}';

    if (nameDesc.contains('station') || nameDesc.contains('terminal')) {
      return StopType.terminal;
    } else if (nameDesc.contains('university') || nameDesc.contains('school')) {
      return StopType.education;
    } else if (nameDesc.contains('market') || nameDesc.contains('shopping')) {
      return StopType.shopping;
    } else if (nameDesc.contains('airport')) {
      return StopType.airport;
    } else if (nameDesc.contains('residential')) {
      return StopType.residential;
    } else {
      return StopType.general;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Stop &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Stop{id: $id, name: $name, isFavorite: $isFavorite}';
  }
}

/// Enum for different stop types (useful for UI icons and styling)
enum StopType {
  general,
  terminal,
  education,
  shopping,
  airport,
  residential,
}

/// Extension for StopType to get display properties
extension StopTypeExtension on StopType {
  String get displayName {
    switch (this) {
      case StopType.general:
        return 'Stop';
      case StopType.terminal:
        return 'Terminal';
      case StopType.education:
        return 'University';
      case StopType.shopping:
        return 'Shopping';
      case StopType.airport:
        return 'Airport';
      case StopType.residential:
        return 'Residential';
    }
  }

  String get iconEmoji {
    switch (this) {
      case StopType.general:
        return '🚌';
      case StopType.terminal:
        return '🚉';
      case StopType.education:
        return '🎓';
      case StopType.shopping:
        return '🛒';
      case StopType.airport:
        return '✈️';
      case StopType.residential:
        return '🏠';
    }
  }
}