
import 'package:flutter_getx_clean_architecture/features/advice/data/data_source/data_source.dart';
import 'package:flutter_getx_clean_architecture/features/advice/domain/entity/advice_entity.dart';
import 'package:flutter_getx_clean_architecture/features/advice/domain/repository/repository.dart';

class AdviceRepositoryImpl implements AdviceRepository {
  final AdviceRemoteDataSource source;

  AdviceRepositoryImpl(this.source);

  @override
  Future<AdviceEntity> getAdvice() async {
    final model = await source.getAdvice();
    return model.toEntity();
  }
  /// đang làm dở
  //  @override
  // Future<Either<Failure, bool>> isGpsEnabled() async {
  //   try {
  //     final result = await source.isGpsEnabled();
  //     return Right(result);
  //   } on PlatformException catch (e) {
  //     return Left(PlatformFailure(e.message ?? ''));
  //   } catch (e) {
  //     return const Left(PlatformFailure('Unexpected error occurred'));
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> startGpsTracking() async {
  //   try {
  //     final result = await source.startGpsTracking();
  //     return Right(result);
  //   } on PlatformException catch (e) {
  //     return Left(PlatformFailure(e.message ?? ''));
  //   } catch (e) {
  //     return const Left(PlatformFailure('Unexpected error occurred'));
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> stopGpsTracking() async {
  //   try {
  //     final result = await source.stopGpsTracking();
  //     return Right(result);
  //   } on PlatformException catch (e) {
  //     return Left(PlatformFailure(e.message ?? ''));
  //   } catch (e) {
  //     return const Left(PlatformFailure('Unexpected error occurred'));
  //   }
  // }

  // @override
  // Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
  //   try {
  //     final location = await source.getCurrentLocation();
  //     return Right(location);
  //   } on PlatformException catch (e) {
  //     return Left(PlatformFailure(e.message ?? ''));
  //   } catch (e) {
  //     return const Left(PlatformFailure('Unexpected error occurred'));
  //   }
  // }

  // @override
  // Stream<Either<Failure, LocationEntity>> getLocationStream() {
  //   try {
  //     return source
  //         .getLocationStream()
  //         .map(
  //           (location) => Right<Failure, LocationEntity>(location),
  //         )
  //         .handleError((error) {
  //       return const Left<Failure, LocationEntity>(
  //         PlatformFailure('Failed to get location update'),
  //       );
  //     });
  //   } catch (e) {
  //     return Stream.value(
  //       const Left(PlatformFailure('Failed to get location stream')),
  //     );
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> requestLocationPermission() async {
  //   try {
  //     final result = await source.requestLocationPermission();
  //     return Right(result);
  //   } on PlatformException catch (e) {
  //     return Left(PlatformFailure(e.message ?? ''));
  //   } catch (e) {
  //     return const Left(PlatformFailure('Unexpected error occurred'));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> openLocationSettings() async {
  //   try {
  //     await source.openLocationSettings();
  //     return const Right(null);
  //   } on PlatformException catch (e) {
  //     return Left(PlatformFailure(e.message ?? ''));
  //   } catch (e) {
  //     return const Left(PlatformFailure('Unexpected error occurred'));
  //   }
  // }

}
