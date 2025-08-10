import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var token = RxnString();
  var user = Rxn<Map<String, dynamic>>();

  // Dummy foydalanuvchi ma'lumotlari
  final _dummyEmail = '1@1.com';
  final _dummyPassword = '111111';

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(
        const Duration(seconds: 1)); // Simulyatsiya uchun kutish

    if (email == _dummyEmail && password == _dummyPassword) {
      // Muvaffaqiyatli kirish
      token.value = 'dummy_token_123456';
      user.value = {'name': 'Test User', 'email': email};

      Get.snackbar('Muvaffaqiyat', 'Tizimga muvaffaqiyatli kirdingiz');
      Get.offAllNamed('/dashboard'); // Yo‘lni o‘z loyihangizga moslang
    } else {
      // Noto‘g‘ri email yoki parol
      Get.snackbar('Xato', 'Email yoki parol noto‘g‘ri');
    }
    isLoading.value = false;
  }

  void logout() {
    token.value = null;
    user.value = null;
    Get.offAllNamed('/login');
  }
}
