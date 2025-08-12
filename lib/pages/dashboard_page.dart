// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:e_ehson/pages/home/home_page.dart'; // HomePage uchun import
import 'package:e_ehson/modules/chat/views/chat_screen.dart'; // ChatScreen uchun import
import 'package:e_ehson/pages/profile/profile_page.dart'; // ProfilePage uchun import

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const ChatScreen(),
      const Center(
        child: Text("Notifications", style: TextStyle(fontSize: 20)),
      ),
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
          TabItem(icon: Icons.notifications_none, title: 'Alerts'),
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
