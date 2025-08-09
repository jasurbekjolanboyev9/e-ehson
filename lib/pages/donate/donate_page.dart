import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_controller.dart';

class DonatePage extends StatelessWidget {
  DonatePage({Key? key}) : super(key: key);

  final DonationController dc = Get.put(DonationController());
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final campaign = Get.arguments?['campaign'] ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text("Ehson qilish")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign['title'] ?? 'Kampaniya',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Maqsad: ${campaign['target'] ?? '---'} so‘m"),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Ehson summasi",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                final amount = double.tryParse(val) ?? 0.0;
                dc.setAmount(amount);
              },
            ),
            const SizedBox(height: 20),
            Obx(() {
              return dc.isProcessing.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          dc.makeDonation(campaign);
                        },
                        child: const Text("Tasdiqlash"),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
