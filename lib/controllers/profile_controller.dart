import 'package:get/get.dart';

class ProfileController extends GetxController {
  var profile = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;

  // Biometrics uchun bool maydon
  var isBiometricEnabled = false.obs;

  // Profilni olish (backenddan yoki mock)
  Future<void> fetch() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Mock delay

    // Bu yerda real API so‘rovi bo‘lishi kerak
    profile.value = {
      'name': 'Serinaqu',
      'email': 'serinaqu@example.com',
      'phone': '+998901234567',
      'donations': [
        {'campaign': 'Kambag‘allar uchun yordam', 'amount': 100.0},
        {'campaign': 'Bolalar ta’limi', 'amount': 50.0},
      ],
    };

    isLoading.value = false;
  }

  // Profilni yangilash funksiyasi
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    isLoading.value = true;
    // Bu yerda backendga yangilash so‘rovi yuboriladi
    // Misol uchun:
    // final response = await dio.post('/api/user/profile/update', data: updatedData);

    // Hoziroq mock yangilash
    profile.value = {...?profile.value, ...updatedData};

    isLoading.value = false;
  }

  // Biometrik autentifikatsiyani yoqish/o‘chirish
  void toggleBiometric(bool enabled) {
    isBiometricEnabled.value = enabled;

    // Bu yerda biometrik sozlamani saqlash (local storage yoki backend)
  }
}
