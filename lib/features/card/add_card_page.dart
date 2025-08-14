import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:e_ehson/features/card/card_controller.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _holderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();

  File? _cardImage;

  // Karta turi (UzCard, Visa, Humo, Boshqa)
  String _selectedCardType = "UzCard";
  final List<String> _cardTypes = ["UzCard", "Visa", "Humo", "Boshqa"];

  // Kamera orqali rasm olish
  Future<void> _pickCardImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _cardImage = File(picked.path);
      });
    }
  }

  // Karta raqamini formatlash (1234 5678 9012 3456)
  void _formatCardNumber(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    final formatted = clean.replaceAllMapped(
        RegExp(r".{4}"), (match) => "${match.group(0)} ");
    _cardNumberController.value = TextEditingValue(
      text: formatted.trim(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  // Amal qilish muddatini formatlash (MM/YY)
  void _formatExpiryDate(String value) {
    final clean = value.replaceAll(RegExp(r'\D'), '');
    String result = clean;
    if (clean.length > 2) {
      result = "${clean.substring(0, 2)}/${clean.substring(2)}";
    }
    _expiryDateController.value = TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Yangi Karta Qo'shish"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 🌈 Zamonaviy karta preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      )
                    ],
                    image: _cardImage != null
                        ? DecorationImage(
                            image: FileImage(_cardImage!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "KARTA PREVIEW (${_selectedCardType})",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _cardNumberController.text.isEmpty
                            ? "**** **** **** ****"
                            : _cardNumberController.text,
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _holderNameController.text.isEmpty
                                ? "KARTA EGASI"
                                : _holderNameController.text.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _expiryDateController.text.isEmpty
                                ? "MM/YY"
                                : _expiryDateController.text,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 👤 Karta egasi
                TextFormField(
                  controller: _holderNameController,
                  decoration: const InputDecoration(
                    labelText: "Karta egasi",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (val) =>
                      val!.isEmpty ? "Karta egasini kiriting" : null,
                ),
                const SizedBox(height: 10),

                // 🔢 Karta raqami
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "Karta raqami",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    _formatCardNumber(val);
                    setState(() {});
                  },
                  validator: (val) => val!.replaceAll(' ', '').length < 16
                      ? "To‘g‘ri karta raqamini kiriting"
                      : null,
                ),
                const SizedBox(height: 10),

                // 📅 Amal qilish muddati
                TextFormField(
                  controller: _expiryDateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amal qilish muddati (MM/YY)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    _formatExpiryDate(val);
                    setState(() {});
                  },
                  validator: (val) => val!.isEmpty || val.length != 5
                      ? "Amal qilish muddatini kiriting"
                      : null,
                ),
                const SizedBox(height: 10),

                // 🔖 Karta turi tanlash
                DropdownButtonFormField<String>(
                  value: _selectedCardType,
                  items: _cardTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: "Karta turi",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _selectedCardType = val!;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 📷 Karta rasmi
                FilledButton.icon(
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text("Karta rasmini olish"),
                  onPressed: _pickCardImage,
                ),
                const SizedBox(height: 20),

                // 💾 Saqlash tugmasi
                FilledButton.icon(
                  icon: const Icon(Icons.save_alt),
                  label: const Text("Karta qo'shish"),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final card = CardModel(
                        holderName: _holderNameController.text,
                        cardNumber: _cardNumberController.text,
                        expiryDate: _expiryDateController.text,
                        cardType: _selectedCardType,
                        cardImage: _cardImage,
                      );
                      Provider.of<CardController>(context, listen: false)
                          .addCard(card);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
