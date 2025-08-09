import 'package:get/get.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/campaign_controller.dart';
import '../controllers/donation_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/admin_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService.instance);
    Get.put(AuthController());
    Get.put(CampaignController());
    Get.put(DonationController());
    Get.put(ProfileController());
    Get.put(AdminController());
  }
}
