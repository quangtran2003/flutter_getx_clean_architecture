import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gps_native_clean_architecture/core/presentation/navigation/app_navigator.dart';
import 'package:gps_native_clean_architecture/core/presentation/navigation/snack_bar_type.dart';
import 'package:gps_native_clean_architecture/core/presentation/widgets/base_get_bts_dialog.dart';
import 'package:get/get.dart';

class AppNavigatorImpl implements AppNavigator {
  @override
  Future<T?>? toNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    return Get.toNamed(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  @override
  Future<T?>? offNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    return Get.offNamed(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  @override
  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    Get.back<T>(
      result: result,
      closeOverlays: closeOverlays,
      canPop: canPop,
      id: id,
    );
  }

  @override
  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    RoutePredicate? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    return Get.offAllNamed(
      newRouteName,
      predicate: predicate,
      arguments: arguments,
      id: id,
      parameters: parameters,
    );
  }

  @override
  Future<T?>? toNamedFactory<T>(
    String page, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    return Get.toNamed(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: false,
      parameters: parameters,
    );
  }

  @override
  Future<T?> showBottomSheet<T>(
    BaseGetBtsDialog bottomSheet, {
    RouteSettings? settings,
  }) {
    return Get.bottomSheet(
      bottomSheet,
      settings: settings,
      isScrollControlled: true,
    );
  }

  @override
  Future<T?> bottomSheet<T>(
    Widget bottomsheet, {
    bool isScrollControlled = false,
  }) {
    return Get.bottomSheet(
      bottomsheet,
      isScrollControlled: isScrollControlled,
    );
  }

  @override
  Future<T?> showDialog<T>(
    BaseGetBtsDialog dialog, {
    RouteSettings? settings,
    bool barrierDismissible = true,
  }) {
    return Get.dialog(
      dialog,
      routeSettings: settings,
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  Future<T?> dialog<T>(
    Widget widget, {
    bool barrierDismissible = true,
  }) {
    return Get.dialog(
      widget,
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  void showSnackBar<T>({
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarType type = SnackBarType.failure,
  }) {
    BotToast.showCustomText(
      duration: message.length > 100 ? 5.seconds : duration,
      align: Alignment.topCenter,
      toastBuilder: (cancel) {
        return Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: type.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 4),
                  blurRadius: 8.1,
                  color: Colors.black.withValues(alpha: 0.15),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                  ),
                ),
                // if (mainButton != null) mainButton,
                InkWell(
                  onTap: cancel,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ).paddingOnly(left: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
