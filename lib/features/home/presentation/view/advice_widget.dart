import 'package:flutter/material.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/controller/home_controller.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/view/component/header_component.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/view/component/infor_card_component.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/view/component/primary_button.dart';
import 'package:get/get.dart';

class AdviceWidget extends StatelessWidget {
  final HomeController controller;
  const AdviceWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const HeaderWidget(
            title: 'Advice',
          ),
          const SizedBox(height: 8),

          // Today's Advice section
          Obx(
            () => InfoCardWidget(
              title: "Today's Advice",
              content: controller.advices.value.slip?.advice ?? 'Empty',
              id: 'ID : ${controller.advices.value.slip?.id ?? '0'}',
              pathIcon: 'assets/images/map-pin-line.png',
            ),
          ),

          // Get New Advice Button
          _buildBtn(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBtn() {
    return Obx(
      () {
        String subtitle = '';
        String title = controller.isLoading.value ? 'Running...' : 'Click';

        if (controller.isLoading.value) {
          switch (controller.currentFetchCount.value) {
            case 1:
              subtitle = 'Running 1/5...';
              break;
            case 2:
              subtitle = 'Running 2/5...';
              break;
            case 3:
              subtitle = 'Running 3/5...';
              break;
            case 4:
              subtitle = 'Running 4/5...';
              break;
            case 5:
              subtitle = 'Running 5/5...';
              break;
            default:
              subtitle = 'Loading...';
          }
        }
        return PrimaryButtonComponent(
          isLoading: controller.isLoading.value,
          subtitle: subtitle,
          title: title,
          onPressed: () => controller.isLoading.value
              ? null
              : controller.fetchMultipleAdvices,
        );
      },
    );
  }
}
