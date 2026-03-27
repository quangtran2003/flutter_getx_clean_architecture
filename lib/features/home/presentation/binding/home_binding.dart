import 'package:gps_native_clean_architecture/core/presentation/bindings/base_bindings_factory.dart';
import 'package:gps_native_clean_architecture/features/home/core/platform/gps_method_chanel.dart';
import 'package:gps_native_clean_architecture/features/home/data/data_source/advice_data_source.dart';
import 'package:gps_native_clean_architecture/features/home/data/data_source/gps_data_source.dart';
import 'package:gps_native_clean_architecture/features/home/data/repository_imp/advice_repository_imp.dart';
import 'package:gps_native_clean_architecture/features/home/data/repository_imp/gps_repository_imp.dart';
import 'package:gps_native_clean_architecture/features/home/domain/repository/advice_repository.dart';
import 'package:gps_native_clean_architecture/features/home/domain/repository/gps_repository.dart';
import 'package:gps_native_clean_architecture/features/home/domain/usecase/advice_usecase_repo.dart';
import 'package:gps_native_clean_architecture/features/home/domain/usecase/gps_usecase_repo.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/controller/home_controller.dart';
import 'package:gps_native_clean_architecture/shared/utils/utils_src.dart';
import 'package:get/get.dart';

class HomeBinding extends BaseBindingsFactory {
  @override
  void bindingsFactoryController() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        getMultipleAdvicesUseCase: Get.find(),
        gpsUsecaseRepo: Get.find(),
      ),
      fenix: true,
    );
  }

  @override
  void bindingsFactoryRepository() {
    Get.lazyPut<AdviceRepository>(
      () => AdviceRepositoryImpl(sl()),
      fenix: true,
    );
    Get.lazyPut<GpsRepository>(
      () => GpsRepositoryImp(sl()),
      fenix: true,
    );
  }

  @override
  void bindingsFactoryUseCase() {
    Get.lazyPut(
      () => GetMultipleAdvicesUseCase(sl()),
      fenix: true,
    );
    Get.lazyPut(
      () => GpsUsecaseRepo(sl()),
      fenix: true,
    );
  }

  @override
  void bindingsFactoryDataSource() {
    // Platform Channel
    Get.lazyPut(() => GpsMethodChannel(), fenix: true);

    Get.lazyPut<AdviceRemoteDataSource>(
      () => AdviceRemoteDataSourceImpl(
        sl(),
      ),
      fenix: true,
    );
    Get.lazyPut<GpsPlatformDataSource>(
      () => GpsPlatformDataSourceImpl(
        methodChannel: Get.find<GpsMethodChannel>(),
      ),
      fenix: true,
    );
  }
}
