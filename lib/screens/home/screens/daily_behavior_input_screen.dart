import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/behavior/controllers/data_controller.dart';
import 'package:get/get.dart';

import '../../behavior/controllers/navigation_controller.dart';
import '../../behavior/controllers/shared_controller.dart';
import '../../behavior/controllers/weight_controller.dart';

import '../../behavior/pages/daily_page.dart';
import '../../behavior/pages/health_data_homepage/fixed_page.dart';
import '../../behavior/pages/monthly_page.dart';
import '../../behavior/pages/weekly_page.dart';
import '../../behavior/theme/app_colors.dart';
import '../../behavior/theme/app_text_styles.dart';
import '../../behavior/widgets/bottom_bar.dart';
import '../home_page.dart';

class DailyBehaviorInputScreen extends StatelessWidget {
  // Kontrolcüler
  final WeightController weightController = Get.put(WeightController());
  final SharedController sharedController = Get.put(SharedController());
  final DataController dataController = Get.put(DataController());
  final NavigationController navController = Get.put(NavigationController());

  // Sayfa listesi
  final List<Widget> pages = [
    FixedPage(),
    DailyPage(),
    WeeklyPage(),
    MonthlyPage(),
  ];
  DailyBehaviorInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Davranışsal Girdiler', style: AppTextStyles.heading),
        backgroundColor: AppColors.primaryColor,
        // Navigator kullanımı
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Obx(() => pages[navController.selectedIndex.value]),  // Seçili sayfayı göster
      bottomNavigationBar: BottomNavigationBarWidget(), // BottomNavigationBarWidget kullanılıyor
    );
  }
}


