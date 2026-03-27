import 'package:dartz/dartz.dart';
import 'package:gps_native_clean_architecture/features/home/core/error/failures.dart';
import 'package:gps_native_clean_architecture/features/home/domain/entity/location_entity.dart';
import 'package:gps_native_clean_architecture/features/home/domain/repository/gps_repository.dart';

class GpsUsecaseRepo {
  final GpsRepository repository;

  GpsUsecaseRepo(this.repository);

  Future<Either<Failure, bool>> startGpsTracking() async {
    return await repository.startGpsTracking();
  }

  Future<Either<Failure, bool>> stopGpsTracking() async {
    return await repository.stopGpsTracking();
  }

  Future<Either<Failure, bool>> isGpsEnabled() async {
    return await repository.isGpsEnabled();
  }

  Stream<Either<Failure, LocationEntity>> getLocationStream() {
    return repository.getLocationStream();
  }

  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    return await repository.getCurrentLocation();
  }

  Future<Either<Failure, bool>> requestLocationPermission() async {
    return await repository.requestLocationPermission();
  }

  Future<Either<Failure, void>> openLocationSettings() async {
    return await repository.openLocationSettings();
  }
}
