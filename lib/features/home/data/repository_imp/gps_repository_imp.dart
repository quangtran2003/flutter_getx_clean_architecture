import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_clean_architecture/features/home/core/error/failures.dart';
import 'package:flutter_getx_clean_architecture/features/home/data/data_source/gps_data_source.dart';
import 'package:flutter_getx_clean_architecture/features/home/domain/entity/location_entity.dart';
import 'package:flutter_getx_clean_architecture/features/home/domain/repository/gps_repository.dart';

class GpsRepositoryImp implements GpsRepository {
  final GpsPlatformDataSource source;

  GpsRepositoryImp(this.source);
  // đang làm dở
  @override
  Future<Either<Failure, bool>> isGpsEnabled() async {
    try {
      final result = await source.isGpsEnabled();
      return Right(result);
    } on PlatformException catch (e) {
      return Left(PlatformFailure(e.message ?? ''));
    } catch (e) {
      return const Left(PlatformFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> startGpsTracking() async {
    try {
      final result = await source.startGpsTracking();
      return Right(result);
    } on PlatformException catch (e) {
      return Left(PlatformFailure(e.message ?? ''));
    } catch (e) {
      return const Left(PlatformFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> stopGpsTracking() async {
    try {
      final result = await source.stopGpsTracking();
      return Right(result);
    } on PlatformException catch (e) {
      return Left(PlatformFailure(e.message ?? ''));
    } catch (e) {
      return const Left(PlatformFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      final location = await source.getCurrentLocation();
      return Right(location.toEntity());
    } on PlatformException catch (e) {
      return Left(PlatformFailure(e.message ?? ''));
    } catch (e) {
      return const Left(PlatformFailure('Unexpected error occurred'));
    }
  }

  @override
  Stream<Either<Failure, LocationEntity>> getLocationStream() {
    try {
      return source
          .getLocationStream()
          .map(
            (location) => Right<Failure, LocationEntity>(location.toEntity()),
          )
          .handleError((error) {
        return const Left<Failure, LocationEntity>(
          PlatformFailure('Failed to get location update'),
        );
      });
    } catch (e) {
      return Stream.value(
        const Left(PlatformFailure('Failed to get location stream')),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final result = await source.requestLocationPermission();
      return Right(result);
    } on PlatformException catch (e) {
      return Left(PlatformFailure(e.message ?? ''));
    } catch (e) {
      return const Left(PlatformFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> openLocationSettings() async {
    try {
      await source.openLocationSettings();
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(PlatformFailure(e.message ?? ''));
    } catch (e) {
      return const Left(PlatformFailure('Unexpected error occurred'));
    }
  }
}
