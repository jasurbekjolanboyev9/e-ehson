import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController pc = Get.find();
  final AuthController ac = Get.find();

  @override
  void initState() {
    super.initState();
    pc.fetch();
  }

  void _showEditProfileDialog() {
    final nameController =
        TextEditingController(text: pc.profile.value?['name'] ?? '');
    final phoneController =
        TextEditingController(text: pc.profile.value?['phone'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profilni tahrirlash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ism')),
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefon')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish')),
          ElevatedButton(
            onPressed: () {
              // Profilni yangilash funksiyasi (controllerda yozilishi kerak)
              pc.updateProfile({
                'name': nameController.text,
                'phone': phoneController.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Saqlash'),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsSummary() {
    final donations = pc.profile.value?['donations'] as List? ?? [];
    final totalAmount = donations.fold<double>(
      0,
      (previousValue, element) =>
          previousValue + (element['amount'] as double? ?? 0),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yordam tarixi',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Umumiy summa: \$${totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final d = donations[index];
                  return ListTile(
                    title: Text(d['campaign'] ?? 'Kampaniya nomi yo‘q'),
                    trailing: Text('\$${d['amount'] ?? 0}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xavfsizlik sozlamalari',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Parolni o‘zgartirish'),
              onTap: () {
                // Parolni o'zgartirish sahifasiga yo'naltirish
              },
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Biometrik autentifikatsiya'),
              trailing: Switch(
                value: pc.isBiometricEnabled.value,
                onChanged: (val) {
                  pc.toggleBiometric(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      body: Obx(() {
        if (pc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = pc.profile.value;
        if (profile == null) {
          return const Center(child: Text('Profil ma\'lumotlari mavjud emas'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Text(profile['name']?[0] ?? 'U'),
                  ),
                  title: Text(profile['name'] ?? ''),
                  subtitle: Text(profile['email'] ?? ''),
                ),
              ),
              _buildDonationsSummary(),
              _buildSecuritySettings(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ac.logout(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Chiqish'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
