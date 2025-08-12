// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  var token = RxnString();
  var user = Rxn<Map<String, dynamic>>();

  final _dummyEmail = '1@1.com';
  final _dummyPassword = '111111';

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    if (email == _dummyEmail && password == _dummyPassword) {
      token.value = 'dummy_token_123456';
      user.value = {'name': 'Test User', 'email': email};
      Get.snackbar(
        'success'.tr,
        'tizimga_muvaffaqiyatli_kirdingiz'.tr,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar(
        'error'.tr,
        'email_yoki_parol_notogri'.tr,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
    isLoading.value = false;
  }

  void logout() {
    emailController.clear();
    passwordController.clear();
    token.value = null;
    user.value = null;
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
