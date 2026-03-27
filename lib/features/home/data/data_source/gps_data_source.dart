import 'package:gps_native_clean_architecture/features/home/core/error/exceptions.dart';
import 'package:gps_native_clean_architecture/features/home/core/platform/gps_method_chanel.dart';
import 'package:gps_native_clean_architecture/features/home/data/model/location_model.dart';

abstract class GpsPlatformDataSource {
  Future<bool> isGpsEnabled();
  Future<bool> startGpsTracking();
  Future<bool> stopGpsTracking();
  Future<LocationModel> getCurrentLocation();
  Stream<LocationModel> getLocationStream();
  Future<bool> requestLocationPermission();
  Future<void> openLocationSettings();
}

class GpsPlatformDataSourceImpl implements GpsPlatformDataSource {
  final GpsMethodChannel methodChannel;

  GpsPlatformDataSourceImpl({required this.methodChannel});

  @override
  Future<bool> isGpsEnabled() async {
    try {
      return await methodChannel.isGpsEnabled();
    } catch (e) {
      throw PlatformException('Failed to check GPS status');
    }
  }

  @override
  Future<bool> startGpsTracking() async {
    try {
      return await methodChannel.startGpsTracking();
    } catch (e) {
      throw PlatformException('Failed to start GPS tracking');
    }
  }

  @override
  Future<bool> stopGpsTracking() async {
    try {
      return await methodChannel.stopGpsTracking();
    } catch (e) {
      throw PlatformException('Failed to stop GPS tracking');
    }
  }

  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      final locationData = await methodChannel.getCurrentLocation();
      if (locationData == null) {
        throw PlatformException('No location data received');
      }
      return LocationModel.fromMap(locationData);
    } catch (e) {
      throw PlatformException('Failed to get current location');
    }
  }

  @override
  Stream<LocationModel> getLocationStream() {
    try {
      return methodChannel.getLocationStream().map(
            (data) => LocationModel.fromMap(data),
          );
    } catch (e) {
      throw PlatformException('Failed to get location stream');
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    try {
      return await methodChannel.requestLocationPermission();
    } catch (e) {
      throw PlatformException('Failed to request location permission');
    }
  }

  @override
  Future<void> openLocationSettings() async {
    try {
      await methodChannel.openLocationSettings();
    } catch (e) {
      throw PlatformException('Failed to open location settings');
    }
  }
}
