import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpPage extends StatelessWidget {
  final faqs = [{'q': 'Qanday qilib ehson qilaman?', 'a': 'Bosh sahifadan kampaniyani tanlab, summa kiriting.'}, {'q': 'Anonim bo\'lish mumkinmi?', 'a': 'Ha, anonim opsiyasi mavjud.'}];
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Yordam')), body: ListView(children: [ ...faqs.map((f) => ExpansionTile(title: Text(f['q']!), children: [Padding(padding: EdgeInsets.all(12), child: Text(f['a']!))])), ListTile(title: Text('Aloqa'), subtitle: Text('support@e-ehson.uz')) ]));
  }
}
