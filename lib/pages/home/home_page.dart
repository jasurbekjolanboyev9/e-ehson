import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // YouTube video URL-lari (mock data)
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
      appBar: AppBar(
        title: const Text('e-Ehson'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Bildirishnomalar sahifasiga o'tish kodini yozing
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Sozlamalar sahifasiga o'tish kodini yozing
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salomlashish qismi
            Row(
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
                      fontSize: isTabletOrBigger ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kampaniyalar ro'yxati (karusel o'rniga)
            const Text(
              "Top kampaniyalar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Kampaniyalarni ketma-ket ko'rsatish
            Column(
              children: [
                _buildCampaignCard(
                  title: "Yozgi yordam kampaniyasi",
                  description:
                      "Qashshoq oilalarga yordam berish uchun kampaniya.",
                  goal: 100000,
                  collected: 45000,
                  color: Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildCampaignCard(
                  title: "Qishki kiyimlar",
                  description: "Qishki kiyimlarni ehtiyojmandlarga tarqatamiz.",
                  goal: 50000,
                  collected: 21000,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildCampaignCard(
                  title: "Ta'lim uchun ehson",
                  description:
                      "Bolalarga ta'lim imkoniyati yaratish maqsadida.",
                  goal: 120000,
                  collected: 72000,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // YouTube videolar ro'yxati
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.red,
                      size: 36,
                    ),
                    title: Text(video['title']!),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      final url = Uri.parse(video['url']!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
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

            const SizedBox(height: 24),

            // Tezkor harakatlar
            const Text(
              "Tezkor harakatlar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.volunteer_activism,
                  label: "Ehson qil",
                  onTap: () {
                    // Ehson qilish sahifasiga yo'naltirish
                  },
                ),
                _ActionButton(
                  icon: Icons.request_page,
                  label: "Talab qo‘yish",
                  onTap: () {
                    // Talab qo'yish sahifasiga yo'naltirish
                  },
                ),
                _ActionButton(
                  icon: Icons.campaign,
                  label: "Kampaniyalar",
                  onTap: () {
                    // Kampaniyalar sahifasiga yo'naltirish
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Statistikalar
            const Text(
              "Statistikalar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatCard(
                    title: "Foydalanuvchilar",
                    value: "1,245",
                    color: Colors.orange),
                _StatCard(
                    title: "Xabarlar", value: "4,567", color: Colors.green),
                _StatCard(
                    title: "Faol Chatlar", value: "34", color: Colors.purple),
              ],
            ),

            const SizedBox(height: 24),

            // Savol-Javob (FAQ) blok
            const Text(
              "Tez-tez so'raladigan savollar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _FaqItem(
              question: "Qanday qilib ehson qilaman?",
              answer:
                  "Ehson qilish uchun 'Ehson qil' tugmasini bosing va kerakli ma'lumotlarni kiriting.",
            ),
            const _FaqItem(
              question: "Talab qanday qo'yiladi?",
              answer:
                  "Siz 'Talab qo‘yish' bo‘limida o‘z so‘rovingizni yuborishingiz mumkin.",
            ),
            const _FaqItem(
              question: "Kampaniyalarga qanday qo‘shilaman?",
              answer:
                  "Faol kampaniyalar ro‘yxatidan keraklisini tanlang va 'Qo‘shilish' tugmasini bosing.",
            ),
          ],
        ),
      ),
    );
  }

  // Kampaniya kartasi widgeti
  Widget _buildCampaignCard({
    required String title,
    required String description,
    required int goal,
    required int collected,
    required Color color,
  }) {
    final double progress = collected / goal;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
            const SizedBox(height: 8),
            Text(description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14)),
            const Spacer(),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              color: color,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(1)}% to‘landi',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// Tezkor harakatlar uchun tugma widgeti
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange.withOpacity(0.2),
            child: Icon(icon, color: Colors.orange, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// Statistikalar uchun karta widgeti
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// Savol-Javob (FAQ) widgeti
class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(widget.answer),
          ),
        ],
        initiallyExpanded: _expanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _expanded = expanded;
          });
        },
      ),
    );
  }
}
