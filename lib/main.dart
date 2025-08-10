import 'dart:async'; // runZonedGuarded uchun kerak
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'theme.dart';
import 'services/localization_service.dart';
import 'services/api_service.dart';
import 'bindings/initial_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global xatoliklarni ushlash uchun zonada ishga tushirish
  runZonedGuarded(() async {
    await ApiService.init();

    runApp(const EEhsonApp());
  }, (error, stackTrace) {
    debugPrint('Global error: $error');
    debugPrintStack(stackTrace: stackTrace);
  });

  // Flutter framework xatoliklari uchun qo‘shimcha tutuvchi
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter framework error: ${details.exception}');
  };
}

class EEhsonApp extends StatelessWidget {
  const EEhsonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'e-Ehson',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light, // Material 3 asosidagi tema
      translations: LocalizationService(), // Lokalizatsiya xizmati
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      initialBinding: InitialBindings(), // GetX Bindinglari
      initialRoute: Routes.SPLASH, // Dastlabki sahifa
      getPages: AppPages.pages, // Marshrutlar ro‘yxati
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
