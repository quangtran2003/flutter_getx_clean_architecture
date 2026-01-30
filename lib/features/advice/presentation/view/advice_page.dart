import 'package:flutter/material.dart';
import 'package:flutter_getx_clean_architecture/core/presentation/widgets/base_get_page.dart';
import 'package:flutter_getx_clean_architecture/features/advice/core/enum/menu_enum.dart';
import 'package:flutter_getx_clean_architecture/features/advice/presentation/controller/advice_controller.dart';
import 'package:flutter_getx_clean_architecture/features/advice/presentation/view/advice_button.dart';
import 'package:flutter_getx_clean_architecture/features/advice/presentation/view/zoomable_floor_plan.dart';
import 'package:get/get.dart';

import 'draggable_bottom_sheet.dart';

class AdvicePage extends BaseGetPage<AdviceController> {
  AdvicePage({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomNavHeight = 80.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Zoomable floor plan
          const Positioned.fill(
            bottom: 80,
            child: ZoomableFloorPlan(
              imagePath: 'assets/images/plan.png',
            ),
          ),

          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: bottomNavHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(MenuEnum.advice),
                  _buildNavItem(MenuEnum.gps),
                ],
              ),
            ),
          ),

          // Draggable Bottom Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomNavHeight,
            child: DraggableBottomSheet(
              minHeight: 150,
              defaultHeight: screenHeight * 0.4,
              maxHeight: screenHeight * 0.7,
              child: _buildBottomSheetContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(MenuEnum menuEnum) {
    return Obx(() {
      final isActive = controller.currentMenu.value == menuEnum;
      return InkWell(
        onTap: () => controller.switchMenu(menuEnum),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              menuEnum == MenuEnum.advice
                  ? menuEnum.icon(
                      isActive: controller.currentMenu.value == MenuEnum.advice)
                  : menuEnum.icon(
                      isActive: controller.currentMenu.value == MenuEnum.gps),
              height: 28,
              width: 28,
            ),
            const SizedBox(height: 4),
            Text(
              menuEnum.label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomSheetContent() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 8),

          // Today's Advice section
          _buildInfoAdvice(),

          // Get New Advice Button
          _buildBtn(),
          const SizedBox(height: 20),

          // Advice List
        ],
      ),
    );
  }

  Center _buildBtn() {
    return Center(
          child: Obx(() => AdviceButton(
                isLoading: controller.isLoading.value,
                currentFetchCount: controller.currentFetchCount.value,
                onPressed: controller.fetchMultipleAdvices,
              )),
        );
  }

  Container _buildInfoAdvice() {
    return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "Today's Advice",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Obx(() => Text(
                    controller.advices.value.slip?.advice ?? 'Empty',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )),
              const SizedBox(height: 8),

              // ID Display
              Obx(() => Text(
                    'ID : ${controller.advices.value.slip?.id ?? '0'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Advice',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {},
        ),
      ],
    );
  }
}
