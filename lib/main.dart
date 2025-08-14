import 'dart:async'; // runZonedGuarded uchun kerak
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'theme.dart';
import 'services/localization_service.dart';
import 'services/api_service.dart';
import 'bindings/initial_bindings.dart';

Future<void> main() async {
  // Flutter bindinglarini ishga tushirish, splash va boshqa async ishlar uchun kerak
  WidgetsFlutterBinding.ensureInitialized();

  // Global xatoliklarni ushlash uchun zonada ishga tushirish
  runZonedGuarded(() async {
    // API xizmatini ishga tushirish (mock yoki real)
    await ApiService.init();

    // Ilovani ishga tushirish
    runApp(const EEhsonApp());
  }, (error, stackTrace) {
    // Global xatoliklar konsolga chiqariladi
    debugPrint('Global error: $error');
    debugPrintStack(stackTrace: stackTrace);
  });

  // Flutter framework xatoliklarini tutish
  FlutterError.onError = (FlutterErrorDetails details) {
    // Xatoliklarni standart tarzda ko‘rsatish
    FlutterError.presentError(details);
    debugPrint('Flutter framework error: ${details.exception}');
    debugPrintStack(stackTrace: details.stack);
  };
}

class EEhsonApp extends StatelessWidget {
  const EEhsonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'e-Ehson',
      debugShowCheckedModeBanner: false, // debug bannerni olib tashlash
      theme: AppTheme.light, // Material 3 asosidagi tema
      translations: LocalizationService(), // Lokalizatsiya xizmati
      locale: LocalizationService.locale, // Ilova boshlanishidagi locale
      fallbackLocale: LocalizationService.fallbackLocale, // Agar locale topilmasa
      initialBinding: InitialBindings(), // GetX Bindinglari
      initialRoute: Routes.SPLASH, // Dastlabki sahifa
      getPages: AppPages.pages, // Marshrutlar ro‘yxati
      defaultTransition: Transition.fade, // O‘tish animatsiyasi
      transitionDuration: const Duration(milliseconds: 300), // Animatsiya davomiyligi
    );
  }
}
