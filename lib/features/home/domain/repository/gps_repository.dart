import 'package:dartz/dartz.dart';
import 'package:gps_native_clean_architecture/features/home/core/error/failures.dart';
import 'package:gps_native_clean_architecture/features/home/domain/entity/location_entity.dart';

abstract class GpsRepository {
  Future<Either<Failure, bool>> isGpsEnabled();
  Future<Either<Failure, bool>> startGpsTracking();
  Future<Either<Failure, bool>> stopGpsTracking();
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
  Stream<Either<Failure, LocationEntity>> getLocationStream();
  Future<Either<Failure, bool>> requestLocationPermission();
  Future<Either<Failure, void>> openLocationSettings();
}
