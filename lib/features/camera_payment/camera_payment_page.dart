import 'package:flutter/material.dart';

class CameraPaymentPage extends StatelessWidget {
  const CameraPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "Scan QR or Card to Pay",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Open Camera"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Camera feature coming soon!")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
