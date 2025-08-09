import 'package:get/get.dart';
import '../services/api_service.dart';

class ProfileController extends GetxController {
  var profile = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final res = await ApiService.instance.get('/api/user/profile');
      profile.value = Map<String, dynamic>.from(res.data);
    } catch (e) {
      Get.snackbar('Xato', 'Profilni olishda xatolik');
    } finally {
      isLoading.value = false;
    }
  }
}
