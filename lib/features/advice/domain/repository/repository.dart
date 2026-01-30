import 'package:flutter_getx_clean_architecture/features/advice/domain/entity/advice_entity.dart';

abstract class AdviceRepository {
  Future<AdviceEntity> getAdvice();

  /// đang làm dở
  // Future<Either<Failure, bool>> isGpsEnabled();
  // Future<Either<Failure, bool>> startGpsTracking();
  // Future<Either<Failure, bool>> stopGpsTracking();
  // Future<Either<Failure, LocationEntity>> getCurrentLocation();
  // Stream<Either<Failure, LocationEntity>> getLocationStream();
  // Future<Either<Failure, bool>> requestLocationPermission();
  // Future<Either<Failure, void>> openLocationSettings();
}
