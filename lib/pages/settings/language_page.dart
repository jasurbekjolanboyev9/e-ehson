import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/localization_service.dart';

class LanguagePage extends StatelessWidget {
  final service = LocalizationService();
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('language'.tr)), body: ListView.builder(itemCount: LocalizationService.langs.length, itemBuilder: (context,i) {
      return ListTile(title: Text(LocalizationService.langs[i]), onTap: () { service.changeLocale(i); Get.back(); });
    }));
  }
}
