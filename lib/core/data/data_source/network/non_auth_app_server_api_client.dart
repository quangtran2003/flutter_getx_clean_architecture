import 'package:dio/dio.dart';
import 'package:gps_native_clean_architecture/core/config/env_config.dart';
import 'package:gps_native_clean_architecture/core/data/data_source/network/dio_builder.dart';
import 'package:gps_native_clean_architecture/core/data/data_source/network/middleware/header_intercepter.dart';
import 'package:gps_native_clean_architecture/core/data/data_source/network/rest_api_client.dart';

class NonAuthAppServerApiClient extends RestApiClient {
  NonAuthAppServerApiClient(
    EnvConfig envConfig,
    HeaderInterceptor headerInterceptor,
  ) : super(
          dio: DioBuilder.createDio(
            options: BaseOptions(baseUrl: envConfig.baseUrl),
            interceptors: [
              headerInterceptor,
            ],
          ),
        );
}
