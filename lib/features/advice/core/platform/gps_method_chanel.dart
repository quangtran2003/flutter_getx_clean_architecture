import 'dart:async';

import 'package:flutter/services.dart';

class GpsMethodChannel {
  static const MethodChannel _channel =
      MethodChannel('com.flutter_getx_clean_architecture/gps');
  static const EventChannel _eventChannel =
      EventChannel('com.flutter_getx_clean_architecture/gps_stream');

  // Singleton
  static final GpsMethodChannel _instance = GpsMethodChannel._internal();
  factory GpsMethodChannel() => _instance;
  GpsMethodChannel._internal();

  Stream<Map<String, dynamic>>? _locationStream;

  /// Check if GPS is enabled on device
  Future<bool> isGpsEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('isGpsEnabled');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check GPS status: ${e.message}");
      return false;
    }
  }

  /// Start GPS tracking (native will send updates every 2 seconds)
  Future<bool> startGpsTracking() async {
    try {
      final bool result = await _channel.invokeMethod('startGpsTracking');
      return result;
    } on PlatformException catch (e) {
      print("Failed to start GPS tracking: ${e.message}");
      return false;
    }
  }

  /// Stop GPS tracking
  Future<bool> stopGpsTracking() async {
    try {
      final bool result = await _channel.invokeMethod('stopGpsTracking');
      return result;
    } on PlatformException catch (e) {
      print("Failed to stop GPS tracking: ${e.message}");
      return false;
    }
  }

  /// Get current location once
  Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      final Map<dynamic, dynamic> result =
          await _channel.invokeMethod('getCurrentLocation');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get current location: ${e.message}");
      return null;
    }
  }

  /// Stream of location updates (every 2 seconds when tracking is active)
  Stream<Map<String, dynamic>> getLocationStream() {
    _locationStream ??= _eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => Map<String, dynamic>.from(event));
    return _locationStream!;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      final bool result =
          await _channel.invokeMethod('requestLocationPermission');
      return result;
    } on PlatformException catch (e) {
      print("Failed to request location permission: ${e.message}");
      return false;
    }
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    try {
      await _channel.invokeMethod('openLocationSettings');
    } on PlatformException catch (e) {
      print("Failed to open location settings: ${e.message}");
    }
  }
}
