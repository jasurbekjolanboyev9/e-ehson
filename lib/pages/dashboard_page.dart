import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 80, color: Colors.orange),
          SizedBox(height: 16),
          Text("Welcome to Bottom Navigation Bar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    ),
    const Center(child: Text("Chat Page", style: TextStyle(fontSize: 20))),
    const Center(child: Text("Notifications", style: TextStyle(fontSize: 20))),
    const Center(child: Text("Profile Page", style: TextStyle(fontSize: 20))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        activeColor: Colors.orange,
        color: Colors.black54,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.chat_bubble_outline, title: 'Chat'),
          TabItem(icon: Icons.notifications_none, title: 'Alerts'),
          TabItem(icon: Icons.person_outline, title: 'Profile'),
        ],
        initialActiveIndex: 0,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
