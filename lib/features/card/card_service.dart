import 'dart:io';
import 'card_controller.dart'; // yoki card_model.dart faylingizga mos ravishda

class CardService {
  // Hozircha local data
  final List<CardModel> _cards = [];

  List<CardModel> getCards() => List.unmodifiable(_cards);

  void addCard(CardModel card) {
    _cards.add(card);
  }

  void removeCard(int index) {
    if (index >= 0 && index < _cards.length) {
      _cards.removeAt(index);
    }
  }

  void updateCard(int index, CardModel updatedCard) {
    if (index >= 0 && index < _cards.length) {
      _cards[index] = updatedCard;
    }
  }

  void setDefaultCard(int index) {
    for (var i = 0; i < _cards.length; i++) {
      _cards[i] = _cards[i].copyWith(isDefault: i == index);
    }
  }
}
