// lib/controllers/navigation_controller.dart

import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Başlangıçta ortada "Fixed" sayfası seçili olacak (index 1)
  var selectedIndex = 0.obs;

  // Sayfa değiştirme işlevi
  void changePage(int index) {
    selectedIndex.value = index;
  }
}
