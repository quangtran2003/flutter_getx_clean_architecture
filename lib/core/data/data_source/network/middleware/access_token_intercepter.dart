import 'package:dio/dio.dart';
import 'package:gps_native_clean_architecture/core/data/data_source/local/local_src.dart';
import 'package:gps_native_clean_architecture/core/data/data_source/network/middleware/base_intercepter.dart';

class AccessTokenInterceptor extends BaseInterceptor {
  AccessTokenInterceptor(this._appHive);

  final AppHive _appHive;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = _appHive.get<String>(HiveKeys.keyJwtToken);
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
