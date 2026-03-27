import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gps_native_clean_architecture/core/presentation/controllers/app_controller.dart';
import 'package:gps_native_clean_architecture/core/presentation/navigation/navigation_src.dart';
import 'package:gps_native_clean_architecture/shared/exceptions/base/app_exception.dart';
import 'package:gps_native_clean_architecture/shared/exceptions/base/app_exception_wrapper.dart';
import 'package:gps_native_clean_architecture/shared/exceptions/exception_handler.dart';
import 'package:gps_native_clean_architecture/shared/exceptions/remote/remote_exception.dart';
import 'package:gps_native_clean_architecture/shared/exceptions/uncaught/app_uncaught_exception.dart';
import 'package:gps_native_clean_architecture/shared/utils/utils_src.dart';
import 'package:get/get.dart';

/// typedef action for [buildState] method
typedef ActionCallback = FutureOr<void> Function();

/// typedef onError for [buildState] method
typedef OnErrorCallback = FutureOr<AppException?> Function(AppException error);

/// typedef for onFinally for [buildState] method
typedef OnFinallyCallback = FutureOr<void> Function();

abstract class BaseGetxController extends GetxController {
  late final AppNavigator nav;
  late final AppController appCtrl;
  late final _exceptionHandler = ExceptionHandler(nav: nav);

  final isLoading = false.obs;
  final isLoadingOverlay = false.obs;
  final appExceptionWrapper = Rxn<AppExceptionWrapper>(null);

  /// [action] Nếu bên trong hàm action có gọi hàm bất đồng bộ thì
  /// `BẮT BUỘC` phải `await` để `buildState` có thể bắt được lỗi nếu xảy ra
  Future<void> buildState({
    required ActionCallback action,
    OnErrorCallback? onError,
    OnFinallyCallback? onFinally,
    bool showLoading = false,
    bool showLoadingOverlay = false,
    bool handleError = true,
    String? overrideErrorMessage,
  }) async {
    bool hideLoadingOnFinally = true;
    try {
      if (showLoadingOverlay) {
        showPageLoadingOverlay();
      }

      if (showLoading) {
        showPageLoading();
      }

      await action();
    } catch (e, stackTrace) {
      logger.e(e, stackTrace: stackTrace);
      final appException = e is AppException ? e : AppUncaughtException(e);

      if (appException.appExceptionType == AppExceptionType.remote) {
        final remoteException = appException as RemoteException;
        if (remoteException.kind == RemoteExceptionKind.cancellation) {
          hideLoadingOnFinally = false;
        }
      }

      // onError nếu được truyền vào sẽ luôn được gọi để controller xử lý thêm nếu cần
      // Nếu onError trả về null thì lỗi đã được xử lý và không cần xử lý tiếp nữa, còn nếu trả về một exception khác để core sẽ xử lý tiếp
      final unHandledException = await onError?.call(appException);
      if (onError != null && unHandledException == null) {
        return;
      }

      if (handleError) {
        final exceptionWrapper = AppExceptionWrapper(
          appException: unHandledException ?? appException,
          stackTrace: stackTrace,
          overrideMessage: overrideErrorMessage,
        );

        // Lưu lại exception để có thể dùng sau nếu cần
        appExceptionWrapper.value = exceptionWrapper;

        // Tự động xử lý exception đã biết
        _exceptionHandler.handleException(exceptionWrapper);
      }
    } finally {
      if (hideLoadingOnFinally) {
        if (showLoading) {
          hidePageLoading();
        }

        if (showLoadingOverlay) {
          hidePageLoadingOverlay();
        }
      }

      await onFinally?.call();
    }
  }

  void showPageLoading() {
    isLoading.value = true;
  }

  void hidePageLoading() {
    isLoading.value = false;
  }

  void showPageLoadingOverlay() {
    isLoadingOverlay.value = true;
  }

  void hidePageLoadingOverlay() {
    isLoadingOverlay.value = false;
  }

  /// Gọi 2 hàm onInit và onReady để giả lập việc controller được khởi tạo khi mở 1 màn hình
  ///
  /// Chỉ dùng khi viết test case
  @visibleForTesting
  @nonVirtual
  void onOpen() {
    onInit();
    onReady();
  }
}
