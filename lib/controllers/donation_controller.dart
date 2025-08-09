import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonationController extends GetxController {
  var amount = 0.0.obs;

  // Ikki nom bilan qo‘llab-quvvatlaymiz (isLoading va isProcessing)
  var isLoading = false.obs;
  RxBool get isProcessing => isLoading;

  var donationSuccess = false.obs;

  /// Summani o‘rnatish
  void setAmount(double value) {
    if (value > 0) {
      amount.value = value;
    }
  }

  /// Ehson qilish
  Future<void> makeDonation(Map<String, dynamic> campaign) async {
    isLoading.value = true;
    donationSuccess.value = false;

    // Server bo‘lmagan versiyada faqat simulyatsiya qilamiz
    await Future.delayed(const Duration(seconds: 2));

    if (amount.value > 0) {
      donationSuccess.value = true;
      Get.snackbar(
        "Rahmat!",
        "Siz ${campaign['title'] ?? 'kampaniya'} uchun ${amount.value} so‘m ehson qildingiz.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
      );
    } else {
      Get.snackbar(
        "Xatolik",
        "Ehson miqdorini kiriting",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFFFC7C7), // rangni hex orqali berdik
      );
    }

    isLoading.value = false;
  }
}
