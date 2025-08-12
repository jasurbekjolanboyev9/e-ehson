import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- To‘g‘rilandi
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var profile = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  var isDarkMode = false.obs;
  var isBiometricEnabled = false.obs;
  var isTwoFactorEnabled = false.obs;
  var isNotificationsEnabled = false.obs;
  var totalDonations = 0.obs;
  var donationAmount = 0.0.obs;
  var userRank = 'Bronze'.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadSettings();
    simulateDonationUpdates();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      profile.value = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'image': null,
        'totalDonations': 5,
        'totalAmount': 500.0,
        'rank': 'Silver Donor',
      };
      totalDonations.value = profile['totalDonations'] ?? 0;
      donationAmount.value = profile['totalAmount'] ?? 0.0;
      userRank.value = profile['rank'] ?? 'Bronze';
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Profilni yuklashda xatolik yuz berdi'.tr,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('darkMode') ?? false;
    isBiometricEnabled.value = prefs.getBool('biometric') ?? false;
    isTwoFactorEnabled.value = prefs.getBool('twoFactor') ?? false;
    isNotificationsEnabled.value = prefs.getBool('notifications') ?? false;
  }

  void toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  void toggleBiometric(bool value) async {
    isBiometricEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric', value);
  }

  void toggleTwoFactor(bool value) async {
    isTwoFactorEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('twoFactor', value);
  }

  void toggleNotifications(bool value) async {
    isNotificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    Get.snackbar(
      'Bildirishnomalar'.tr,
      value ? 'Yoqildi'.tr : 'O‘chirildi'.tr,
      backgroundColor: Colors.black.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void deleteAccount() {
    Get.snackbar(
      'Hisob o‘chirildi'.tr,
      'Hisobingiz muvaffaqiyatli o‘chirildi'.tr,
      backgroundColor: Colors.red.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void updateProfile(String name, String email) {
    profile.value = {
      ...profile.value,
      'name': name,
      'email': email,
    };
    Get.snackbar(
      'Profil yangilandi'.tr,
      'Profil ma\'lumotlari yangilandi'.tr,
      backgroundColor: Colors.green.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  Future<void> changeProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profile.value = {
        ...profile.value,
        'image': File(pickedFile.path),
      };
      Get.snackbar(
        'Rasm o‘zgartirildi'.tr,
        'Profil rasmi muvaffaqiyatli o‘zgartirildi'.tr,
        backgroundColor: Colors.green.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  void viewDonationHistory() {
    Get.toNamed('/donation-history');
  }

  void shareProfile() {
    Get.snackbar(
      'Profil ulashildi'.tr,
      'Profilingiz do‘stlaringizga ulashildi'.tr,
      backgroundColor: Colors.green.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void simulateDonationUpdates() async {
    await Future.delayed(const Duration(seconds: 2));
    totalDonations.value += 1;
    donationAmount.value += 100.0;
    calculateRank();
  }

  void addCustomDonation(double amount) {
    donationAmount.value += amount;
    totalDonations.value += 1;
    profile.value = {
      ...profile.value,
      'totalDonations': totalDonations.value,
      'totalAmount': donationAmount.value,
    };
    calculateRank();
    Get.snackbar(
      'Ehson qo‘shildi'.tr,
      'Siz $amount summa ehson qildingiz'.tr,
      backgroundColor: Colors.green.withOpacity(0.5),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void calculateRank() {
    if (donationAmount.value > 1000) {
      userRank.value = 'Platinum Donor';
    } else if (donationAmount.value > 500) {
      userRank.value = 'Gold Donor';
    } else if (donationAmount.value > 100) {
      userRank.value = 'Silver Donor';
    } else {
      userRank.value = 'Bronze Donor';
    }
    profile.value = {...profile.value, 'rank': userRank.value};
  }

  void showCustomDonationDialog() {
    final controller = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('Ehson qo‘shish'.tr),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Summa (\$)',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Bekor qilish'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                addCustomDonation(amount);
                Get.back();
              } else {
                Get.snackbar(
                  'Xato'.tr,
                  'Iltimos, to‘g‘ri summa kiriting'.tr,
                  backgroundColor: Colors.red.withOpacity(0.5),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 8,
                );
              }
            },
            child: Text('Qo‘shish'.tr),
          ),
        ],
      ),
    );
  }
}
