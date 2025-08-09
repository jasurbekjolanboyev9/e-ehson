import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool loading = false;
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      loading = true;
    });
    final res = await ApiService.instance.get('/api/statistics');
    setState(() {
      stats = res.data ?? {};
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistika")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: stats.entries
                  .map((e) => ListTile(
                        title: Text(e.key),
                        trailing: Text("${e.value}"),
                      ))
                  .toList(),
            ),
    );
  }
}
