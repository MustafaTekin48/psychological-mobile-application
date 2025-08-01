// lib/data/data_controller.dart

import 'package:get/get.dart';
import '../models/user_data.dart';

class DataController extends GetxController {
  var userData = UserData().obs;

  // VKİ Hesaplama
  void updateBMI() {
    if (userData.value.height > 0 && userData.value.weight > 0) {
      userData.value.bmi = userData.value.weight / ((userData.value.height / 100) * (userData.value.height / 100));
    } else {
      userData.value.bmi = null;
    }
    userData.refresh();
  }
}
