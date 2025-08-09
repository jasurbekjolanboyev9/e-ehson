import 'package:get/get.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var token = RxnString();
  var user = Rxn<Map<String, dynamic>>();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final res = await ApiService.instance.post('/api/auth/login', {'email': email, 'password': password});
      token.value = res.data['token'];
      user.value = Map<String, dynamic>.from(res.data['user']);
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Xato', 'Kirishda xatolik: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    token.value = null;
    user.value = null;
    Get.offAllNamed('/login');
  }
}
