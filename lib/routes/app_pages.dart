import 'package:gps_native_clean_architecture/features/home/presentation/binding/home_binding.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/view/home_page.dart';
import 'package:gps_native_clean_architecture/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home.path,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
