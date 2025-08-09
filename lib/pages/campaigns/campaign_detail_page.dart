import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaign = Get.parameters; // Demo uchun params
    return Scaffold(
      appBar: AppBar(title: const Text("Kampaniya tafsilotlari")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign['title'] ?? 'No title',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text("Maqsad: ${campaign['target'] ?? '---'} so‘m"),
            const Spacer(),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.toNamed(
                  Routes.DONATE,
                  arguments: {'campaign': campaign},
                ),
                child: const Text('Ehson qil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
