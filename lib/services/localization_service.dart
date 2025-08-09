import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocalizationService extends Translations {
  static final locale = Locale('uz', 'UZ');
  static final fallbackLocale = Locale('en', 'US');

  static final langs = ['O\'zbek', 'Русский', 'English'];
  static final locales = [Locale('uz', 'UZ'), Locale('ru', 'RU'), Locale('en', 'US')];

  @override
  Map<String, Map<String, String>> get keys => {
    'uz_UZ': {'welcome':'Xush kelibsiz', 'login':'Kirish', 'donate':'Ehson qil', 'profile':'Profil', 'language':'Til'},
    'ru_RU': {'welcome':'Добро пожаловать', 'login':'Вход','donate':'Пожертвовать','profile':'Профиль','language':'Язык'},
    'en_US': {'welcome':'Welcome', 'login':'Login','donate':'Donate','profile':'Profile','language':'Language'}
  };

  void changeLocale(int index) => Get.updateLocale(locales[index]);
}
