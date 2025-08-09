import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';

class AdminPage extends StatelessWidget {
  final AdminController ac = Get.find();
  @override
  Widget build(BuildContext context) {
    ac.loadMock();
    return Scaffold(appBar: AppBar(title: Text('Admin')), body: Obx(() => ac.pending.isEmpty ? Center(child: Text('Pending yo\'q')) : ListView.builder(itemCount: ac.pending.length, itemBuilder: (context,i) {
      final p = ac.pending[i];
      return Card(child: ListTile(title: Text(p['title']), subtitle: Text('Summa: ${p['amount']}'), trailing: Wrap(children: [ElevatedButton(onPressed: () => ac.approve(p['id']), child: Text('Tasdiqlash')), OutlinedButton(onPressed: () => ac.reject(p['id']), child: Text('Rad etish'))])));
    })));
  }
}
