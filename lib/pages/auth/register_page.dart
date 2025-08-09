import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class RegisterPage extends StatelessWidget {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Ro\'yxatdan o\'tish')), body: Padding(
      padding: EdgeInsets.all(12),
      child: Card(child: Padding(padding: EdgeInsets.all(12), child: Column(children: [
        CustomTextField(controller: _name, label: 'Ism'),
        SizedBox(height: 8),
        CustomTextField(controller: _email, label: 'Email'),
        SizedBox(height: 8),
        CustomTextField(controller: _pass, label: 'Parol', obscure: true),
        SizedBox(height: 12),
        CustomButton(label: 'Ro\'yxatdan o\'tish', onTap: ()=>Get.snackbar('Info','Demo register: \${_email.text}'))
      ]))),
    ));
  }
}
