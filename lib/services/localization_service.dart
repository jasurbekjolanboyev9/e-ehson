// lib/services/localization_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  static final locale = Locale('uz', 'UZ');
  static final fallbackLocale = Locale('en', 'US');

  static final langs = ['O\'zbek', 'Русский', 'English'];
  static final locales = [
    Locale('uz', 'UZ'),
    Locale('ru', 'RU'),
    Locale('en', 'US')
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'uz_UZ': {
          'welcome': 'Xush kelibsiz',
          'login': 'Kirish',
          'register': 'Ro\'yxatdan o\'tish',
          'donate': 'Ehson qil',
          'profile': 'Profil',
          'language': 'Til',
          'dashboard': 'Bosh sahifa',
          'error': 'Xato',
          'success': 'Muvaffaqiyat',
          'page_not_found': 'Sahifa topilmadi',
          'security_code': 'Xavfsizlik kodi',
          'sent_verification_code':
              'Biz siz kiritgan telefon raqamiga tasdiqlash kodini yubordik.',
          'wrong_number':
              'Telefon raqami noto‘g‘ri? To‘g‘ri raqamni kiriting\nQayta yuborish %s soniyadan keyin mumkin',
          'next': 'Keyingi',
          'skip': 'O‘tkazib yuborish',
          'email': 'Email',
          'password': 'Parol',
          'tizimga_muvaffaqiyatli_kirdingiz':
              'Tizimga muvaffaqiyatli kirdingiz',
          'email_yoki_parol_notogri': 'Email yoki parol noto‘g‘ri',
          'Ehson statistikasi': 'Ehson statistikasi',
          'Jami ehsonlar': 'Jami ehsonlar',
          'Jami summa': 'Jami summa',
          'Daraja': 'Daraja',
          'Ehson tarixi': 'Ehson tarixi',
          'Maxsus ehson qo‘shish': 'Maxsus ehson qo‘shish',
          'Qo‘shish': 'Qo‘shish',
          'Iltimos, to‘g‘ri summa kiriting': 'Iltimos, to‘g‘ri summa kiriting',
          'Parolni o‘zgartirish': 'Parolni o‘zgartirish',
          'Biometrik autentifikatsiya': 'Biometrik autentifikatsiya',
          'Ikki bosqichli tekshirish (2FA)': 'Ikki bosqichli tekshirish (2FA)',
          'Tilni o‘zgartirish': 'Tilni o‘zgartirish',
          'Tungi rejim': 'Tungi rejim',
          'Bildirishnomalarni sozlash': 'Bildirishnomalarni sozlash',
          'Profilni ulashish': 'Profilni ulashish',
          'Hisobni o‘chirish': 'Hisobni o‘chirish',
          'Diqqat': 'Diqqat!',
          'Hisobingizni butunlay o‘chirmoqchimisiz':
              'Hisobingizni butunlay o‘chirmoqchimisiz?',
          'Bekor qilish': 'Bekor qilish',
          'Ha, o‘chir': 'Ha, o‘chir',
          'Saqlash': 'Saqlash',
          'Ism': 'Ism',
          'Email': 'Email',
          'Bildirishnomalar': 'Bildirishnomalar',
          'Yoqildi': 'Yoqildi',
          'O‘chirildi': 'O‘chirildi',
          'Hisob o‘chirildi': 'Hisob o‘chirildi',
          'Hisobingiz muvaffaqiyatli o‘chirildi':
              'Hisobingiz muvaffaqiyatli o‘chirildi',
          'Profil yangilandi': 'Profil yangilandi',
          'Profil ma\'lumotlari yangilandi': 'Profil ma\'lumotlari yangilandi',
          'Rasm o‘zgartirildi': 'Rasm o‘zgartirildi',
          'Profil rasmi muvaffaqiyatli o‘zgartirildi':
              'Profil rasmi muvaffaqiyatli o‘zgartirildi',
          'Profil ulashildi': 'Profil ulashildi',
          'Profilingiz do‘stlaringizga ulashildi':
              'Profilingiz do‘stlaringizga ulashildi',
          'Ehson qo‘shildi': 'Ehson qo‘shildi',
          'Xabar yozing...': 'Xabar yozing...',
          'Salom, qanday yordam bera olaman?':
              'Salom, qanday yordam bera olaman?',
          'Bizga oziq-ovqat kerak.': 'Bizga oziq-ovqat kerak.',
          'Rahmat, juda yaxshi bo‘lardi!': 'Rahmat, juda yaxshi bo‘lardi!',
          // lib/services/localization_service.dart (add to 'uz_UZ')
          'Assalomu alaykum, Jasurbek!': 'Assalomu alaykum, Jasurbek!',
          'Bosh sahifa': 'Bosh sahifa',
          'Ehson qilish': 'Ehson qilish',
          'Talab qo‘yish': 'Talab qo‘yish',
          'Kampaniyalar': 'Kampaniyalar',
          'Profil': 'Profil',
          'Statistika': 'Statistika',
          'Yordam': 'Yordam',
          'Top kampaniyalar': 'Top kampaniyalar',
          'Yozgi yordam kampaniyasi': 'Yozgi yordam kampaniyasi',
          'Qashshoq oilalarga yordam berish uchun kampaniya.':
              'Qashshoq oilalarga yordam berish uchun kampaniya.',
          'Qishki kiyimlar': 'Qishki kiyimlar',
          'Qishki kiyimlarni ehtiyojmandlarga tarqatamiz.':
              'Qishki kiyimlarni ehtiyojmandlarga tarqatamiz.',
          'Ta\'lim uchun ehson': 'Ta\'lim uchun ehson',
          'Bolalarga ta\'lim imkoniyati yaratish maqsadida.':
              'Bolalarga ta\'lim imkoniyati yaratish maqsadida.',
          '% to‘landi': '% to‘landi',
          'Foydali videolar': 'Foydali videolar',
          'Video ochilmadi': 'Video ochilmadi',
          'Tezkor harakatlar': 'Tezkor harakatlar',
          'Ehson qil': 'Ehson qil',
          'Statistikalar': 'Statistikalar',
          'Foydalanuvchilar': 'Foydalanuvchilar',
          'Xabarlar': 'Xabarlar',
          'Faol Chatlar': 'Faol Chatlar',
          'Tez-tez so\'raladigan savollar': 'Tez-tez so\'raladigan savollar',
          'Qanday qilib ehson qilaman?': 'Qanday qilib ehson qilaman?',
          'Ehson qilish uchun \'Ehson qil\' tugmasini bosing va kerakli ma\'lumotlarni kiriting.':
              'Ehson qilish uchun \'Ehson qil\' tugmasini bosing va kerakli ma\'lumotlarni kiriting.',
          'Talab qanday qo\'yiladi?': 'Talab qanday qo\'yiladi?',
          'Siz \'Talab qo‘yish\' bo‘limida o‘z talablaringizni kiritishingiz mumkin.':
              'Siz \'Talab qo‘yish\' bo‘limida o‘z talablaringizni kiritishingiz mumkin.',
          'Kampaniyalarga qanday qo‘shilaman?':
              'Kampaniyalarga qanday qo‘shilaman?',
          'Kampaniyalar bo‘limidan kerakli kampaniyani tanlab, qo‘shilishingiz mumkin.':
              'Kampaniyalar bo‘limidan kerakli kampaniyani tanlab, qo‘shilishingiz mumkin.',
        },
        'ru_RU': {
          // Add Russian translations as needed
        },
        'en_US': {
          // Add English translations as needed
        }
      };

  void changeLocale(int index) => Get.updateLocale(locales[index]);
}
