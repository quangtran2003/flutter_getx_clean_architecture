import 'package:flutter/material.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/controller/home_controller.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/view/component/header_component.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/view/component/infor_card_component.dart';
import 'package:gps_native_clean_architecture/features/home/presentation/view/component/primary_button.dart';
import 'package:get/get.dart';

class GpsWidget extends StatelessWidget {
  final HomeController controller;
  const GpsWidget({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const HeaderWidget(
            title: 'GPS',
          ),
          const SizedBox(height: 8),

          // "MY LOCATION"
          Obx(
            () => InfoCardWidget(
              title: "MY LOCATION",
              pathIcon: 'assets/images/map-pin-line.png',
              id: !controller.isLoading.value
                  ? 'Standby'
                  : 'Lat: ${controller.currentLocation.value?.latitude ?? '0'} - Lng: ${controller.currentLocation.value?.longitude ?? '0'}',
            ),
          ),

          // GPS Button
          _buildBtn(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBtn() {
    return Obx(() {
      String subtitle = '';
      String title = controller.isLoading.value ? 'Running...' : 'Click';

      if (!controller.isGpsEnabled.value) {
        title = 'Enable GPS';
        subtitle = 'GPS is Disabled';
      } else if (controller.isLoading.value) {
        title = 'Stop';
        subtitle = 'GPS System is Running ...';
      } else {
        title = 'Start';
        subtitle = 'Standby';
      }
      return PrimaryButtonComponent(
        isLoading: controller.isLoading.value,
        subtitle: subtitle,
        title: title,
        onPressed: controller.toggleGpsTracking,
      );
    });
  }
}
