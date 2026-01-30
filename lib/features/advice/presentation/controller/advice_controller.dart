import 'package:flutter_getx_clean_architecture/core/presentation/controllers/base_getx_controller.dart';
import 'package:flutter_getx_clean_architecture/features/advice/core/enum/menu_enum.dart';
import 'package:flutter_getx_clean_architecture/features/advice/domain/entity/advice_entity.dart';
import 'package:flutter_getx_clean_architecture/features/advice/domain/usecase/advice_usecase_repo.dart';
import 'package:get/get.dart';

class AdviceController extends BaseGetxController {
  final GetMultipleAdvicesUseCase getMultipleAdvicesUseCase;

  AdviceController({required this.getMultipleAdvicesUseCase});

  final Rx<AdviceEntity> advices = AdviceEntity().obs;
  final RxInt currentFetchCount = 0.obs;
  final Rx<MenuEnum> currentMenu = MenuEnum.advice.obs;

  void fetchMultipleAdvices() async {
    if (isLoading.value) return;

    isLoading.value = true;
    currentFetchCount.value = 0;

    //  try {
    for (int i = 0; i < 5; i++) {
      final advice = await getMultipleAdvicesUseCase.call();
      advices.value = advice; // Thêm vào đầu list để hiển thị mới nhất
      currentFetchCount.value = i + 1;
      await Future.delayed(const Duration(seconds: 3)); // Delay 3s
    }
    // } catch (e) {
    //   Get.snackbar('Error', 'Failed to fetch advice: $e');
    // }

    isLoading.value = false;
    currentFetchCount.value = 0;
  }



  void switchMenu(MenuEnum menu) {
    currentMenu.value = menu;
  }
}
