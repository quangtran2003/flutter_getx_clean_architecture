import 'package:flutter_getx_clean_architecture/core/config/env_config.dart';
import 'package:flutter_getx_clean_architecture/core/data/data_source/local/local_src.dart';
import 'package:flutter_getx_clean_architecture/core/data/data_source/network/network_src.dart';
import 'package:flutter_getx_clean_architecture/core/presentation/controllers/app_controller.dart';
import 'package:flutter_getx_clean_architecture/core/presentation/navigation/navigation_src.dart';
import 'package:flutter_getx_clean_architecture/shared/exceptions/exception_handler.dart';
import 'package:flutter_getx_clean_architecture/shared/utils/utils_src.dart';
import 'package:get/get.dart';

import 'base_bindings.dart';

class AppBinding extends BaseBindings {
  Future<void> bind({
    required AppEnv env,
  }) async {
    await bindingsCore(env);
    dependencies();
  }

  Future<void> bindingsCore(AppEnv env) async {
    Get.put<EnvConfig>(
      switch (env) {
        AppEnv.dev => EnvConfigDev(),
        AppEnv.prod => EnvConfigProd(),
      },
      permanent: true,
    );
    await [
      Get.putAsync<AppHive>(AppHiveImpl.instance.init, permanent: true),
      Get.putAsync(AppInfo().init, permanent: true)
    ].wait;
    Get.put<AppNavigator>(AppNavigatorImpl(), permanent: true);
    Get.put(ExceptionHandler(nav: sl()), permanent: true);
    Get.put(HeaderInterceptor(sl()), permanent: true);
    Get.put(AccessTokenInterceptor(sl()), permanent: true);
    Get.put(
      AuthAppServerApiClient(sl(), sl(), sl()),
      permanent: true,
    );
    Get.put(NonAuthAppServerApiClient(sl(), sl()), permanent: true);
  }

  @override
  void bindingsController() {
    Get.put(AppController(), permanent: true);
  }

  @override
  void bindingsRepository() {}

  @override
  void bindingsUseCase() {}
}
