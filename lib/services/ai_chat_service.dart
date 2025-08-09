import 'dart:async';

class AIChatService {
  static Future<String> getReply(String message) async {
    await Future.delayed(Duration(milliseconds: 400));
    final m = message.toLowerCase();
    if (m.contains('salom') || m.contains('hello')) return 'Assalomu alaykum! Men e-Ehson yordamchisi. Qanday yordam bera olaman?';
    if (m.contains('ehson')) return 'Ehson qilish uchun kampaniyani tanlang va summa kiriting. Men demo rejimda yordam beraman.';
    if (m.contains('qanday') || m.contains('qani')) return 'Siz kampaniyani tanlab, “Ehson qil” tugmasini bosing va ko‘rsatmalarga amal qiling.';
    return 'Kechirasiz, hozircha men bu savolga aniq javob bera olmayman. Iltimos, boshqa tarzda so‘rab ko‘ring.';
  }
}
