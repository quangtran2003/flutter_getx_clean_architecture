import 'package:gps_native_clean_architecture/env/env_dev.dart';
import 'package:gps_native_clean_architecture/env/env_prod.dart';

enum AppEnv {
  dev,
  prod;
}

abstract class EnvConfig {
  final String baseUrl;
  final AppEnv env;

  EnvConfig({
    required this.baseUrl,
    required this.env,
  });
}

class EnvConfigDev extends EnvConfig {
  EnvConfigDev()
      : super(
          baseUrl: EnvDev.baseUrl,
          env: AppEnv.dev,
        );
}

class EnvConfigProd extends EnvConfig {
  EnvConfigProd()
      : super(
          baseUrl: EnvProd.baseUrl,
          env: AppEnv.prod,
        );
}
