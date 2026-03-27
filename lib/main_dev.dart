import 'package:flutter/material.dart';
import 'package:gps_native_clean_architecture/core/config/env_config.dart';
import 'package:gps_native_clean_architecture/core/presentation/app.dart';
import 'package:gps_native_clean_architecture/core/presentation/bindings/app_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBinding().bind(env: AppEnv.dev);
  runApp(App());
}
