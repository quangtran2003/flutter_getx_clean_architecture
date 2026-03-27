import 'package:flutter/material.dart';
import 'package:gps_native_clean_architecture/core/presentation/navigation/snack_bar_type.dart';
import 'package:gps_native_clean_architecture/core/presentation/widgets/base_get_bts_dialog.dart';

abstract class AppNavigator {
  Future<T?>? toNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  });

  Future<T?>? offNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  });

  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  });

  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    RoutePredicate? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  });

  Future<T?>? toNamedFactory<T>(
    String page, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  });

  /// Show bottom sheet phức tạp cho [BaseGetBtsDialog] có controller
  Future<T?> showBottomSheet<T>(
    BaseGetBtsDialog bottomSheet, {
    RouteSettings? settings,
  });

  /// Show bottom sheet đơn giản
  Future<T?> bottomSheet<T>(
    Widget bottomsheet, {
    bool isScrollControlled = false,
  });

  /// Show dialog phức tạp cho [BaseGetBtsDialog] có controller
  Future<T?> showDialog<T>(
    BaseGetBtsDialog dialog, {
    RouteSettings? settings,
    bool barrierDismissible = true,
  });

  /// Show dialog đơn giản
  Future<T?> dialog<T>(
    Widget widget, {
    bool barrierDismissible = true,
  });

  void showSnackBar<T>({
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarType type = SnackBarType.failure,
  });
}
