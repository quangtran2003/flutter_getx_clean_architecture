import 'package:flutter_getx_clean_architecture/features/advice/presentation/binding/advice_binding.dart';
import 'package:flutter_getx_clean_architecture/features/advice/presentation/view/advice_page.dart';
import 'package:flutter_getx_clean_architecture/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.advice.path,
      page: () => AdvicePage(),
      binding: AdviceBinding(),
    ),
  ];
}
