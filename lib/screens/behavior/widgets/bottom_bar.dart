import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../theme/app_colors.dart';
import '../controllers/navigation_controller.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final NavigationController navController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SalomonBottomBar(
            selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.primaryColor.withOpacity(0.7),
        currentIndex: navController.selectedIndex.value,
        onTap: (index) => navController.changePage(index),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Veriler"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text("Günlük"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.calendar_view_week),
            title: Text("Haftalık"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.calendar_month),
            title: Text("Aylık"),
          ),
        ],
      ),
    );
  }
}
