// lib/features/card/card_list_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_ehson/features/card/card_controller.dart';

class CardListWidget extends StatelessWidget {
  const CardListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CardController>(
      builder: (context, controller, child) {
        if (controller.cards.isEmpty) {
          return const Center(child: Text("No cards added yet."));
        }
        return ListView.builder(
          itemCount: controller.cards.length,
          itemBuilder: (context, index) {
            final card = controller.cards[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(Icons.credit_card,
                    color: card.isDefault ? Colors.orange : Colors.grey),
                title: Text(card.cardNumber),
                subtitle: Text("${card.holderName} • ${card.expiryDate}"),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "default") {
                      controller.setDefaultCard(index);
                    } else if (value == "delete") {
                      controller.removeCard(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: "default", child: Text("Set as Default")),
                    const PopupMenuItem(value: "delete", child: Text("Delete")),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
