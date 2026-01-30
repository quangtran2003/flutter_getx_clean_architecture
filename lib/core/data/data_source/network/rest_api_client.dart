import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_getx_clean_architecture/core/data/model/server_error.dart';
import 'package:flutter_getx_clean_architecture/shared/exceptions/remote/remote_exception.dart';

enum RestMethod { get, post, put, patch, delete }

class RestApiClient {
  RestApiClient({
    required this.dio,
  });

  final Dio dio;

  Future<dynamic> request({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _requestByMethod(
        method: method,
        path: path,
        queryParameters: queryParameters,
        body: body,
        options: Options(
          headers: options?.headers,
          contentType: options?.contentType,
          responseType: options?.responseType,
          sendTimeout: options?.sendTimeout,
          receiveTimeout: options?.receiveTimeout,
        ),
        cancelToken: cancelToken,
      );

      // Có nhiều API dù có lỗi vẫn trả về 200 OK, nên cần kiểm tra dựa vào code để xử lý lỗi
      final data = response.data;
      if (data is Map<String, dynamic> && data['code'] == '01') {
        final serverError = ServerError.fromJson(data);
        throw RemoteException(
          kind: RemoteExceptionKind.serverDefined,
          httpErrorCode: response.statusCode,
          serverError: serverError,
        );
      }

      return data;
    } catch (error) {
      throw _buildDioException(error);
    }
  }

  Future<Response<dynamic>> _requestByMethod({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  }) {
    switch (method) {
      case RestMethod.get:
        return dio.get(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
      case RestMethod.post:
        return dio.post(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
      case RestMethod.patch:
        return dio.patch(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
      case RestMethod.put:
        return dio.put(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
      case RestMethod.delete:
        return dio.delete(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
    }
  }

  RemoteException _buildDioException(Object? exception) {
    if (exception is RemoteException) {
      return exception;
    }

    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.cancel:
          return RemoteException(
            kind: RemoteExceptionKind.cancellation,
            rootException: exception,
          );
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return RemoteException(
            kind: RemoteExceptionKind.timeout,
            rootException: exception,
          );
        case DioExceptionType.badResponse:
          final httpErrorCode = exception.response?.statusCode ?? -1;

          /// server-defined error
          if (exception.response?.data != null) {
            final serverError = ServerError.fromJson(exception.response!.data!);

            return RemoteException(
              kind: RemoteExceptionKind.serverDefined,
              httpErrorCode: httpErrorCode,
              serverError: serverError,
              rootException: exception,
            );
          }

          return RemoteException(
            kind: RemoteExceptionKind.serverUndefined,
            httpErrorCode: httpErrorCode,
            rootException: exception,
          );
        case DioExceptionType.badCertificate:
          return RemoteException(
            kind: RemoteExceptionKind.badCertificate,
            rootException: exception,
          );
        case DioExceptionType.connectionError:
          return RemoteException(
            kind: RemoteExceptionKind.network,
            rootException: exception,
          );
        case DioExceptionType.unknown:
          if (exception.error is SocketException) {
            return RemoteException(
              kind: RemoteExceptionKind.network,
              rootException: exception,
            );
          }

          if (exception.error is RemoteException) {
            return exception.error as RemoteException;
          }
      }
    }

    return RemoteException(
      kind: RemoteExceptionKind.unknown,
      rootException: exception,
    );
  }
}
