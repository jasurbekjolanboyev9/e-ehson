import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController pc = Get.find();
  final AuthController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    pc.fetch();
    return Scaffold(appBar: AppBar(title: Text('Profil')), body: Obx(() => pc.isLoading.value ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(padding: EdgeInsets.all(12), child: Column(children: [
      Card(child: ListTile(leading: CircleAvatar(child: Text(pc.profile.value?['name']?[0] ?? 'U')), title: Text(pc.profile.value?['name'] ?? ''), subtitle: Text(pc.profile.value?['email'] ?? ''))),
      SizedBox(height: 12),
      Card(child: Padding(padding: EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Yordam tarixi', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        ...List<Widget>.from((pc.profile.value?['donations'] as List? ?? []).map((d) => ListTile(title: Text(d['campaign']), trailing: Text('${d['amount']}'))))
      ]))),
      SizedBox(height: 12),
      ElevatedButton(onPressed: () => ac.logout(), child: Text('Chiqish'))
    ]))));
  }
}
