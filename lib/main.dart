import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'theme.dart';
import 'services/localization_service.dart';
import 'services/api_service.dart';
import 'bindings/initial_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // API yoki boshqa servislarni boshlash
  await ApiService.init();

  runApp(const EEhsonApp());
}

class EEhsonApp extends StatelessWidget {
  const EEhsonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'e-Ehson',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light, // theme.dart
      translations: LocalizationService(), // services/localization_service.dart
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      initialBinding: InitialBindings(), // bindings/initial_bindings.dart
      initialRoute: Routes.SPLASH, // routes.dart
      getPages: AppPages.pages, // routes.dart ichidagi sahifalar
    );
  }
}
