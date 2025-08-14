// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:e_ehson/pages/home/home_page.dart'; // HomePage
import 'package:e_ehson/modules/chat/views/chat_screen.dart'; // ChatScreen
import 'package:e_ehson/pages/profile/profile_page.dart'; // ProfilePage
import 'package:e_ehson/features/card/add_card_page.dart'; // Cards

// Kamera orqali to‘lov uchun placeholder sahifa
class CameraPaymentPage extends StatelessWidget {
  const CameraPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined,
                size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "Kamera orqali to'lov bo‘limi\n(keyinchalik real ishlashga tayyor)",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // ✅ Bo‘limlar tartibi: Home, Chat, Camera, Cards, Profile
    _pages = [
      const HomePage(),
      const ChatScreen(),
      const CameraPaymentPage(), // 3-o‘rinda Camera
      AddCardPage(), // 4-o‘rinda Cards
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: Colors.white,
        activeColor: Colors.orange,
        color: Colors.black54,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.chat_bubble_outline, title: 'Chat'),
          TabItem(
              icon: Icons.camera_alt_outlined,
              title: 'Camera'), // Camera bo‘limi
          TabItem(icon: Icons.credit_card, title: 'Cards'), // Cards bo‘limi
          TabItem(icon: Icons.person_outline, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
