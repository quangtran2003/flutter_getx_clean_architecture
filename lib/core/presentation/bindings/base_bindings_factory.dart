import 'package:flutter/foundation.dart';
import 'package:flutter_getx_clean_architecture/shared/utils/utils_src.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

abstract class BaseBindingsFactory extends Bindings {
  @override
  @nonVirtual
  void dependencies() {
    GetInterfaceExt.increaseTag();
    bindingsFactoryDataSource();
    bindingsFactoryRepository();
    bindingsFactoryUseCase();
    bindingsFactoryController();
  }

  void bindingsFactoryDataSource();

  /// Chỉ sử dụng `putFactory`, `lazyPutFactory`, `findFactory` trong hàm này, ngoại trừ find các singleton instance
  void bindingsFactoryRepository();

  /// Chỉ sử dụng `putFactory`, `lazyPutFactory`, `findFactory` trong hàm này, ngoại trừ find các singleton instance
  void bindingsFactoryUseCase();

  /// Chỉ sử dụng `putFactory`, `lazyPutFactory`, `findFactory` trong hàm này, ngoại trừ find các singleton instance
  void bindingsFactoryController();
}

class BindingsFactoryBuilder extends BaseBindingsFactory {
  final BindingBuilderCallback? bindingsFactoryControllerBuilder;
  final BindingBuilderCallback? bindingsFactoryRepositoryBuilder;
  final BindingBuilderCallback? bindingsFactoryUseCaseBuilder;
  final BindingBuilderCallback? bindingsFactoryDataSourceBuilder;

  BindingsFactoryBuilder({
    this.bindingsFactoryControllerBuilder,
    this.bindingsFactoryRepositoryBuilder,
    this.bindingsFactoryUseCaseBuilder,
    this.bindingsFactoryDataSourceBuilder,
  });

  @override
  void bindingsFactoryController() {
    bindingsFactoryControllerBuilder?.call();
  }

  @override
  void bindingsFactoryRepository() {
    bindingsFactoryRepositoryBuilder?.call();
  }

  @override
  void bindingsFactoryUseCase() {
    bindingsFactoryUseCaseBuilder?.call();
  }

  @override
  void bindingsFactoryDataSource() {
    bindingsFactoryDataSourceBuilder?.call();
  }
}
