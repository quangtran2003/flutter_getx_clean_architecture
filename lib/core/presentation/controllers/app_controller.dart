import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gps_native_clean_architecture/core/presentation/controllers/base_getx_controller.dart';

class AppController extends BaseGetxController {
  @override
  void onInit() {
    super.onInit();
    _configSystemUI();
  }

  void _configSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Đảm bảo status bar và navigation bar trong suốt
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor:
            Colors.transparent, // Thanh điều hướng trong suốt
        systemNavigationBarContrastEnforced: false,
        statusBarColor: Colors.transparent, // Thanh trạng thái trong suốt
        statusBarIconBrightness: Brightness.dark, // Icon màu đen
      ),
    );
  }

  void changeTheme() {}

  void changeLanguage() {}
}
