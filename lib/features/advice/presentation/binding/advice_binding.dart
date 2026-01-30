import 'package:flutter_getx_clean_architecture/core/presentation/bindings/base_bindings_factory.dart';
import 'package:flutter_getx_clean_architecture/features/advice/data/data_source/data_source.dart';
import 'package:flutter_getx_clean_architecture/features/advice/data/repository_imp/repository_imp.dart';
import 'package:flutter_getx_clean_architecture/features/advice/domain/repository/repository.dart';
import 'package:flutter_getx_clean_architecture/features/advice/domain/usecase/advice_usecase_repo.dart';
import 'package:flutter_getx_clean_architecture/features/advice/presentation/controller/advice_controller.dart';
import 'package:flutter_getx_clean_architecture/shared/utils/utils_src.dart';
import 'package:get/get.dart';

class AdviceBinding extends BaseBindingsFactory {
  @override
  void bindingsFactoryController() {
    Get.lazyPut<AdviceController>(
      () => AdviceController(
        getMultipleAdvicesUseCase: Get.find(),
      ),
    );
  }

  @override
  void bindingsFactoryRepository() {
    Get.lazyPut<AdviceRemoteDataSource>(() => AdviceRemoteDataSourceImpl(sl()));
    Get.lazyPut<AdviceRepository>(() => AdviceRepositoryImpl(sl()));
  }

  @override
  void bindingsFactoryUseCase() {
    Get.lazyPut(() => GetMultipleAdvicesUseCase(sl()));
  }
}
