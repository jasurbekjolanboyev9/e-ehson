import 'dart:io';

class CardModel {
  final String holderName;
  final String cardNumber;
  final String expiryDate;
  final String cardType; // UzCard, Visa, Humo, Boshqa
  final File? cardImage; // Kamera orqali yoki fayldan olingan rasm

  CardModel({
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
    this.cardImage,
  });
}
