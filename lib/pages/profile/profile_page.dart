// lib/pages/profile/profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import 'package:confetti/confetti.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key}); // Removed const constructor

  final ProfileController pc = Get.put(ProfileController());
  final AuthController ac = Get.find();
  final ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  void _showEditProfileSheet() {
    final TextEditingController nameController =
        TextEditingController(text: pc.profile['name']);
    final TextEditingController emailController =
        TextEditingController(text: pc.profile['email']);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ism'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedScaleButton(
              onPressed: () {
                pc.updateProfile(nameController.text, emailController.text);
                Get.back();
              },
              child: Text('Saqlash'.tr),
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfileImage() {
    pc.changeProfileImage();
  }

  Widget _buildDonationsSummary() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ehson statistikasi'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(() => AnimatedCount(
                      count: pc.totalDonations.value,
                      duration: const Duration(seconds: 1),
                      child:
                          Text('Jami ehsonlar: ${pc.totalDonations.value}'.tr),
                    )),
                Obx(() => AnimatedCount(
                      count: pc.donationAmount.value,
                      duration: const Duration(seconds: 1),
                      child:
                          Text('Jami summa: \$${pc.donationAmount.value}'.tr),
                    )),
                Obx(() => Text('Daraja: ${pc.userRank.value}'.tr)),
                const SizedBox(height: 12),
                AnimatedScaleButton(
                  onPressed: pc.viewDonationHistory,
                  child: Text('Ehson tarixi'.tr),
                ),
                AnimatedScaleButton(
                  onPressed: () {
                    pc.addCustomDonation(100.0);
                    confettiController.play();
                    pc.calculateRank();
                  },
                  child: const Text('100\$ Ehson qo\'shish'),
                ),
                AnimatedScaleButton(
                  onPressed: pc.showCustomDonationDialog,
                  child: Text('Maxsus ehson qo‘shish'.tr),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.red],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, size: 40),
            title: Text('Parolni o‘zgartirish'.tr),
            onTap: () => Get.toNamed('/reset'),
          ),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SwitchListTile(
                  key: ValueKey<bool>(pc.isBiometricEnabled.value),
                  secondary: const Icon(Icons.fingerprint),
                  title: Text('Biometrik autentifikatsiya'.tr),
                  value: pc.isBiometricEnabled.value,
                  onChanged: pc.toggleBiometric,
                ),
              )),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SwitchListTile(
                  key: ValueKey<bool>(pc.isTwoFactorEnabled.value),
                  secondary: const Icon(Icons.security),
                  title: Text('Ikki bosqichli tekshirish (2FA)'.tr),
                  value: pc.isTwoFactorEnabled.value,
                  onChanged: pc.toggleTwoFactor,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExtraSettings() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Tilni o‘zgartirish'.tr),
            onTap: () => Get.toNamed('/language'),
          ),
          Obx(() => SwitchListTile(
                secondary: const Icon(Icons.dark_mode, size: 40),
                title: Text('Tungi rejim'.tr),
                value: pc.isDarkMode.value,
                onChanged: pc.toggleDarkMode,
              )),
          Obx(() => SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: Text('Bildirishnomalarni sozlash'.tr),
                value: pc.isNotificationsEnabled.value,
                onChanged: pc.toggleNotifications,
              )),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text('Profilni ulashish'.tr),
            onTap: pc.shareProfile,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              'Hisobni o‘chirish'.tr,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Get.defaultDialog(
                title: 'Diqqat!'.tr,
                middleText: 'Hisobingizni butunlay o‘chirmoqchimisiz?'.tr,
                textCancel: 'Bekor qilish'.tr,
                textConfirm: 'Ha, o‘chir'.tr,
                confirmTextColor: Colors.white,
                onConfirm: () {
                  pc.deleteAccount();
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditProfileSheet,
          ),
        ],
      ),
      body: Obx(() {
        if (pc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = pc.profile.value;
        if (profile.isEmpty) {
          return Center(child: Text('Profil ma\'lumotlari mavjud emas'.tr));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Hero(
                tag: 'profile_image',
                child: GestureDetector(
                  onTap: _changeProfileImage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: profile['image'] != null
                          ? FileImage(profile['image'] as File)
                          : null,
                      child: profile['image'] == null
                          ? Text(
                              (profile['name']?.isNotEmpty ?? false)
                                  ? profile['name'][0]
                                  : 'U',
                              style: const TextStyle(fontSize: 24),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(profile['name'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge),
              Text(profile['email'] ?? '',
                  style: Theme.of(context).textTheme.bodySmall),
              _buildDonationsSummary(),
              _buildSecuritySettings(),
              _buildExtraSettings(),
              const SizedBox(height: 20),
              AnimatedScaleButton(
                onPressed: ac.logout,
                child: Text('Chiqish'.tr),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class AnimatedCount extends StatelessWidget {
  final num count;
  final Duration duration;
  final Widget child;

  const AnimatedCount({
    super.key,
    required this.count,
    required this.duration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<num>(
      tween: Tween(begin: 0, end: count),
      duration: duration,
      builder: (context, value, _) => child,
    );
  }
}

class AnimatedScaleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedScaleButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        // Optional: Add scale animation on tap
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(1.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: child,
        ),
      ),
    );
  }
}
