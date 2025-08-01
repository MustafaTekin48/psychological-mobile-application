// Kullanıcı verilerini tutan sınıf

class UserData {
  double height; // Boy
  double weight; // Kilo
  double? bmi;   // Vücut Kitle İndeksi

  double sleepHours; // Uyku süresi (günlük)
  int cigarettes;    // Sigara (günlük/haftalık)
  int alcoholUnits;  // Alkol (günlük/haftalık)
  double waterIntake; // Su tüketimi (günlük)

  int exerciseFrequency; // Spor yapma aralığı (haftalık)
  double bloodPressure;  // Tansiyon (aylık)
  double sugarLevel;     // Şeker (aylık)
  int heartRate;         // Nabız (aylık)

  UserData({
    this.height = 0.0,
    this.weight = 0.0,
    this.bmi,
    this.sleepHours = 0.0,
    this.cigarettes = 0,
    this.alcoholUnits = 0,
    this.waterIntake = 0.0,
    this.exerciseFrequency = 0,
    this.bloodPressure = 0.0,
    this.sugarLevel = 0.0,
    this.heartRate = 0,
  });

  // BMI hesaplama
  void calculateBMI() {
    if (height > 0 && weight > 0) {
      bmi = weight / ((height / 100) * (height / 100));
    }
  }
}
