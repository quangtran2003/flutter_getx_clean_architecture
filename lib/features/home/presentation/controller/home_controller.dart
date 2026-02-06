import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_getx_clean_architecture/core/presentation/controllers/base_getx_controller.dart';
import 'package:flutter_getx_clean_architecture/features/home/core/enum/menu_enum.dart';
import 'package:flutter_getx_clean_architecture/features/home/domain/entity/advice_entity.dart';
import 'package:flutter_getx_clean_architecture/features/home/domain/entity/location_entity.dart';
import 'package:flutter_getx_clean_architecture/features/home/domain/usecase/advice_usecase_repo.dart';
import 'package:flutter_getx_clean_architecture/features/home/domain/usecase/gps_usecase_repo.dart';
import 'package:get/get.dart';

class HomeController extends BaseGetxController {
  final GetMultipleAdvicesUseCase getMultipleAdvicesUseCase;
  final GpsUsecaseRepo gpsUsecaseRepo;

  HomeController({
    required this.getMultipleAdvicesUseCase,
    required this.gpsUsecaseRepo,
  });
  // Observable variables
  final RxBool isGpsEnabled = false.obs;
  final Rx<LocationEntity?> currentLocation = Rx<LocationEntity?>(null);

  StreamSubscription<dynamic>? _locationStreamSubscription;
  final Rx<AdviceEntity> advices = AdviceEntity().obs;
  final RxInt currentFetchCount = 0.obs;
  final Rx<MenuEnum> currentMenu = MenuEnum.advice.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   checkGpsStatus();
  // }

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

  Future<void> checkGpsStatus() async {
    final result = await gpsUsecaseRepo.isGpsEnabled();
    result.fold(
      (failure) {
        showError(failure.message);
        isGpsEnabled.value = false;
      },
      (enabled) {
        isGpsEnabled.value = enabled;
      },
    );
  }

  Future<void> toggleGpsTracking() async {
    if (isLoading.value) {
      await stopTracking();
    } else {
      await startTracking();
    }
  }

  Future<void> startTracking() async {
    // // Check GPS status first
    // await checkGpsStatus();

    // if (!isGpsEnabled.value) {
    //   showError('GPS is not enabled. Please enable GPS.');
    //   return;
    // }

    final result = await gpsUsecaseRepo.startGpsTracking();

    result.fold(
      (failure) {
        showError(failure.message);
        isLoading.value = false;
      },
      (success) {
        if (success) {
          isLoading.value = true;
          _listenToLocationUpdates();
        }
      },
    );
  }

  void showError(String error) {
    Get.snackbar(
      'Lỗi',
      error,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> stopTracking() async {
    final result = await gpsUsecaseRepo.stopGpsTracking();

    result.fold(
      (failure) {
        showError(failure.message);
      },
      (success) {
        if (success) {
          isLoading.value = false;
          _cancelLocationUpdates();
        }
      },
    );
  }

  void _listenToLocationUpdates() {
    _locationStreamSubscription?.cancel();

    _locationStreamSubscription = gpsUsecaseRepo.getLocationStream().listen(
      (result) {
        result.fold(
          (failure) {
            showError(failure.message);
          },
          (location) {
            currentLocation.value = location;
          },
        );
      },
      onError: (error) {
        showError('Failed to get location updates');
      },
    );
  }

  void _cancelLocationUpdates() {
    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
  }

  @override
  void onClose() {
    _cancelLocationUpdates();
    super.onClose();
  }
}
