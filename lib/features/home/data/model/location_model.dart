import 'package:gps_native_clean_architecture/features/home/domain/entity/location_entity.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final DateTime timestamp;
  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    required this.timestamp,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      accuracy:
          map['accuracy'] != null ? (map['accuracy'] as num).toDouble() : null,
      altitude:
          map['altitude'] != null ? (map['altitude'] as num).toDouble() : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  LocationEntity toEntity() => LocationEntity(
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        altitude: altitude,
        timestamp: timestamp,
      );
}
