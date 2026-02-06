import 'package:flutter/material.dart';
import 'package:flutter_getx_clean_architecture/core/presentation/widgets/base_get_page.dart';
import 'package:flutter_getx_clean_architecture/features/home/core/enum/menu_enum.dart';
import 'package:flutter_getx_clean_architecture/features/home/presentation/controller/home_controller.dart';
import 'package:flutter_getx_clean_architecture/features/home/presentation/view/advice_widget.dart';
import 'package:flutter_getx_clean_architecture/features/home/presentation/view/draggable_bottom_sheet.dart';
import 'package:flutter_getx_clean_architecture/features/home/presentation/view/gps_widget.dart';
import 'package:flutter_getx_clean_architecture/features/home/presentation/view/zoomable_floor_plan.dart';
import 'package:get/get.dart';

class HomePage extends BaseGetPage<HomeController> {
  HomePage({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomNavHeight = 80.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          //   Zoomable floor plan
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
          Obx(
            () => Positioned(
              left: 0,
              right: 0,
              bottom: bottomNavHeight,
              child: DraggableBottomSheet(
                minHeight: 150,
                defaultHeight: screenHeight * 0.4,
                maxHeight: screenHeight * 0.7,
                child: controller.currentMenu.value == MenuEnum.advice
                    ? AdviceWidget(controller: controller)
                    : GpsWidget(controller: controller),
              ),
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
}
