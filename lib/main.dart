import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes.dart';
import 'theme.dart';
import 'services/localization_service.dart';
import 'services/api_service.dart';
import 'bindings/initial_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.initMock();
  runApp(EEhsonApp());
}

class EEhsonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'e-Ehson',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      translations: LocalizationService(),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      initialBinding: InitialBindings(),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}
