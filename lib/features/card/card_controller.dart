import 'dart:io';
import 'package:flutter/material.dart';

class CardModel {
  final String holderName;
  final String cardNumber;
  final String expiryDate;
  final String cardType; // Visa, UzCard, Humo, Boshqa
  final File? cardImage; // Kamera yoki fayldan olingan rasm
  final bool isDefault;

  CardModel({
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
    this.cardImage,
    this.isDefault = false,
  });

  CardModel copyWith({
    String? holderName,
    String? cardNumber,
    String? expiryDate,
    String? cardType,
    File? cardImage,
    bool? isDefault,
  }) {
    return CardModel(
      holderName: holderName ?? this.holderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      cardImage: cardImage ?? this.cardImage,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class CardController extends ChangeNotifier {
  final List<CardModel> _cards = [];

  List<CardModel> get cards => List.unmodifiable(_cards);

  void addCard(CardModel card) {
    _cards.add(card);
    notifyListeners();
  }

  void removeCard(int index) {
    _cards.removeAt(index);
    notifyListeners();
  }

  void setDefaultCard(int index) {
    for (var i = 0; i < _cards.length; i++) {
      _cards[i] = _cards[i].copyWith(isDefault: i == index);
    }
    notifyListeners();
  }
}
