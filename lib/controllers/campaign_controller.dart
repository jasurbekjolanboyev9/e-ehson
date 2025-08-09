import 'package:get/get.dart';
import '../services/api_service.dart';

class CampaignController extends GetxController {
  var campaigns = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final res = await ApiService.instance.get('/api/campaigns');
      campaigns.assignAll(List<Map<String, dynamic>>.from(res.data['campaigns']));
    } catch (e) {
      Get.snackbar('Xato', 'Kampaniyalarni olishda xatolik');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? findById(int id) => campaigns.firstWhereOrNull((c) => c['id'] == id);
}
