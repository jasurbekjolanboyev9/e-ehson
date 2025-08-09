import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ResetPasswordPage extends StatelessWidget {
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Parolni tiklash')), body: Padding(
      padding: EdgeInsets.all(12),
      child: Card(child: Padding(padding: EdgeInsets.all(12), child: Column(children: [
        CustomTextField(controller: _email, label: 'Email'),
        SizedBox(height: 12),
        CustomButton(label: 'Yuborish', onTap: ()=>Get.snackbar('Info','Password reset link sent (demo)'))
      ]))),
    ));
  }
}
