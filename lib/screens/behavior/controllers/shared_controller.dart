import 'package:get/get.dart';

class SharedController extends GetxController {
  // Observable data across pages
  var sleepHours = 0.0.obs;
  var cigaretteUsage = 0.obs;
  var alcoholConsumption = 0.obs;
  var waterIntake = 0.0.obs;
  var strenuousExercise = 0.obs;
  var moderateExercise = 0.obs;
  var lightExercise = 0.obs;
  var systolicPressure = 120.0.obs;
  var diastolicPressure = 80.0.obs;
  var bloodSugar = 90.0.obs;
  var pulseRate = 70.0.obs;
  var bodyWeight = 70.0.obs;

  // Method to update daily-specific data
  void updateDailyData({
    double? sleepHours,
    int? cigaretteUsage,
    int? alcoholConsumption,
    double? waterIntake,
  }) {
    if (sleepHours != null) this.sleepHours.value = sleepHours;
    if (cigaretteUsage != null) this.cigaretteUsage.value = cigaretteUsage;
    if (alcoholConsumption != null) this.alcoholConsumption.value = alcoholConsumption;
    if (waterIntake != null) this.waterIntake.value = waterIntake;
  }

  // Generic method to save data across pages
  Future<void> saveData({
    double? sleepHours,
    int? cigaretteUsage,
    int? alcoholConsumption,
    double? waterIntake,
    int? strenuousExercise,
    int? moderateExercise,
    int? lightExercise,
    double? systolicPressure,
    double? diastolicPressure,
    double? bloodSugar,
    double? pulseRate,
    double? bodyWeight,
  }) async {
    if (sleepHours != null) this.sleepHours.value = sleepHours;
    if (cigaretteUsage != null) this.cigaretteUsage.value = cigaretteUsage;
    if (alcoholConsumption != null) this.alcoholConsumption.value = alcoholConsumption;
    if (waterIntake != null) this.waterIntake.value = waterIntake;
    if (strenuousExercise != null) this.strenuousExercise.value = strenuousExercise;
    if (moderateExercise != null) this.moderateExercise.value = moderateExercise;
    if (lightExercise != null) this.lightExercise.value = lightExercise;
    if (systolicPressure != null) this.systolicPressure.value = systolicPressure;
    if (diastolicPressure != null) this.diastolicPressure.value = diastolicPressure;
    if (bloodSugar != null) this.bloodSugar.value = bloodSugar;
    if (pulseRate != null) this.pulseRate.value = pulseRate;
    if (bodyWeight != null) this.bodyWeight.value = bodyWeight;

    await Future.delayed(Duration(milliseconds: 300)); // Simulate async action
  }
}
