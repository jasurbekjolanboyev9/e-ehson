import 'package:get/get.dart';

class AdminController extends GetxController {
  var pending = <Map<String, dynamic>>[].obs;

  void loadMock() {
    pending.assignAll([
      {'id': 101, 'title': "So'rov 1", 'amount': 50000},
      {'id': 102, 'title': "So'rov 2", 'amount': 120000},
    ]);
  }

  void approve(int id) {
    pending.removeWhere((p) => p['id'] == id);
    Get.snackbar('Admin', 'So\'rov tasdiqlandi: $id');
  }

  void reject(int id) {
    pending.removeWhere((p) => p['id'] == id);
    Get.snackbar('Admin', 'So\'rov rad etildi: $id');
  }
}
