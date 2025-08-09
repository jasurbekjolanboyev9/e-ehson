import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/campaign_controller.dart';
import '../../routes.dart';

class CampaignsPage extends StatelessWidget {
  final CampaignController cc = Get.find();

  @override
  Widget build(BuildContext context) {
    cc.fetch();
    return Scaffold(appBar: AppBar(title: Text('Kampaniyalar')), body: Obx(() => cc.isLoading.value ? Center(child: CircularProgressIndicator()) : ListView.builder(itemCount: cc.campaigns.length, itemBuilder: (context, i) {
      final c = cc.campaigns[i];
      return Card(child: ListTile(title: Text(c['title']), subtitle: Text('${c['collected']} / ${c['target']}'), trailing: Wrap(spacing: 6, children: [
        ElevatedButton(onPressed: () => Get.toNamed(Routes.CAMPAIGN_DETAIL, parameters: {'id': '${c['id']}'}), child: Text('Batafsil')),
        OutlinedButton(onPressed: () => Get.toNamed(Routes.DONATE, arguments: {'campaign': c}), child: Text('Ehson')),
      ])));
    })));
  }
}
