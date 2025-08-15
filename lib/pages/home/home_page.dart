import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Mock YouTube videolar
  static const List<Map<String, String>> youtubeVideos = [
    {
      'title': 'Ehson haqida umumiy ma\'lumot',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    },
    {
      'title': 'Moliyaviy yordam qanday ishlaydi?',
      'url': 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
    },
    {
      'title': 'Qanday qilib kampaniyaga qo\'shilamiz?',
      'url': 'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrBigger = size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          // Chap tomonda doimiy menyu
          Container(
            width: 250,
            color: Colors.orange,
            child: _buildSideMenu(context),
          ),

          // Dashboard qismi
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(isTabletOrBigger),
                  const SizedBox(height: 24),
                  _buildTopCampaigns(),
                  const SizedBox(height: 24),
                  _buildYouTubeVideos(context),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildStatistics(),
                  const SizedBox(height: 24),
                  _buildFAQ(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chap tomon menyu
  Widget _buildSideMenu(BuildContext context) {
    return Column(
      children: [
        const DrawerHeader(
          child: Text(
            'e-Ehson Menu',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        _SideMenuItem(icon: Icons.home, label: 'Bosh sahifa'),
        _SideMenuItem(icon: Icons.volunteer_activism, label: 'Ehson qilish'),
        _SideMenuItem(icon: Icons.request_page, label: 'Talab qo‘yish'),
        _SideMenuItem(icon: Icons.campaign, label: 'Kampaniyalar'),
        _SideMenuItem(icon: Icons.person, label: 'Profil'),
        _SideMenuItem(icon: Icons.bar_chart, label: 'Statistika'),
        _SideMenuItem(icon: Icons.help, label: 'Yordam'),
      ],
    );
  }

  // Greeting
  Widget _buildGreeting(bool isTablet) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage('assets/avatar.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Assalomu alaykum, Jasurbek!",
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Top campaigns
  Widget _buildTopCampaigns() {
    List<Map<String, dynamic>> campaigns = [
      {
        'title': "Yozgi yordam kampaniyasi",
        'description': "Qashshoq oilalarga yordam berish uchun kampaniya.",
        'goal': 100000,
        'collected': 45000,
        'color': Colors.orange
      },
      {
        'title': "Qishki kiyimlar",
        'description': "Qishki kiyimlarni ehtiyojmandlarga tarqatamiz.",
        'goal': 50000,
        'collected': 21000,
        'color': Colors.blue
      },
      {
        'title': "Ta'lim uchun ehson",
        'description': "Bolalarga ta'lim imkoniyati yaratish maqsadida.",
        'goal': 120000,
        'collected': 72000,
        'color': Colors.green
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top kampaniyalar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: campaigns.map((campaign) {
              double progress = campaign['collected'] / campaign['goal'];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign['title'],
                        style: TextStyle(
                            color: campaign['color'],
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign['description'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      LinearPercentIndicator(
                        lineHeight: 10,
                        percent: progress,
                        backgroundColor: campaign['color'].withOpacity(0.2),
                        progressColor: campaign['color'],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% to‘landi',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // YouTube videos
  Widget _buildYouTubeVideos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Foydali videolar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children: youtubeVideos.map((video) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill,
                    color: Colors.red, size: 36),
                title: Text(video['title']!),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  final url = Uri.parse(video['url']!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Video ochilmadi")),
                    );
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Quick Actions
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tezkor harakatlar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _ActionButton(icon: Icons.volunteer_activism, label: "Ehson qil"),
            _ActionButton(icon: Icons.request_page, label: "Talab qo‘yish"),
            _ActionButton(icon: Icons.campaign, label: "Kampaniyalar"),
          ],
        ),
      ],
    );
  }

  // Statistics
  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Statistikalar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatCard(
                title: "Foydalanuvchilar",
                value: "1,245",
                color: Colors.orange),
            _StatCard(title: "Xabarlar", value: "4,567", color: Colors.green),
            _StatCard(title: "Faol Chatlar", value: "34", color: Colors.purple),
          ],
        ),
      ],
    );
  }

  // FAQ
  Widget _buildFAQ() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Tez-tez so'raladigan savollar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _FaqItem(
          question: "Qanday qilib ehson qilaman?",
          answer:
              "Ehson qilish uchun 'Ehson qil' tugmasini bosing va kerakli ma'lumotlarni kiriting.",
        ),
        _FaqItem(
          question: "Talab qanday qo'yiladi?",
          answer:
              "Siz 'Talab qo‘yish' bo‘limida o‘z talablaringizni kiritishingiz mumkin.",
        ),
        _FaqItem(
          question: "Kampaniyalarga qanday qo‘shilaman?",
          answer:
              "Kampaniyalar bo‘limidan kerakli kampaniyani tanlab, qo‘shilishingiz mumkin.",
        ),
      ],
    );
  }
}

// Side Menu Item
class _SideMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SideMenuItem(
      {required this.icon, required this.label, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap ?? () {},
    );
  }
}

// Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton(
      {required this.icon, required this.label, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.orange.withOpacity(0.2),
            child: Icon(icon, color: Colors.orange, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

// Stat Card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard(
      {required this.title,
      required this.value,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// FAQ Item
class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(answer),
        )
      ],
    );
  }
}
