import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class RequestAidPage extends StatefulWidget {
  @override State<StatefulWidget> createState() => _RequestAidState();
}

class _RequestAidState extends State<RequestAidPage> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _reason = TextEditingController();
  var status = ''.obs;
  var sending = false.obs;

  void submit() async {
    final t = _title.text.trim();
    final a = double.tryParse(_amount.text.trim()) ?? 0;
    final r = _reason.text.trim();
    if (t.isEmpty || a <= 0 || r.isEmpty) { Get.snackbar('Xato', 'Barcha maydonlarni to\'ldiring'); return; }
    sending.value = true;
    try {
      final res = await ApiService.instance.post('/api/request-aid', {'title': t, 'amount': a, 'reason': r});
      status.value = 'Yuborildi (ID: ${res.data['request_id']})';
    } catch (e) {
      Get.snackbar('Xato', 'Xato: $e');
    } finally {
      sending.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Ehson talab qilish')), body: Padding(padding: EdgeInsets.all(12), child: Card(child: Padding(padding: EdgeInsets.all(12), child: Column(children: [
      TextField(controller: _title, decoration: InputDecoration(labelText: 'Mavzu', border: OutlineInputBorder())),
      SizedBox(height: 8),
      TextField(controller: _amount, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Summa (UZS)', border: OutlineInputBorder())),
      SizedBox(height: 8),
      TextField(controller: _reason, maxLines: 4, decoration: InputDecoration(labelText: 'Asos', border: OutlineInputBorder())),
      SizedBox(height: 12),
      Obx(() => sending.value ? CircularProgressIndicator() : ElevatedButton(onPressed: submit, child: Text('Yuborish'))),
      SizedBox(height: 12),
      Obx(() => Text(status.value)),
    ]))))); 
  }
}
