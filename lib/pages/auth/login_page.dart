import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../routes.dart';

class LoginPage extends StatelessWidget {
  final AuthController auth = Get.find();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      body: Center(
        child: Container(
          width: isWide ? 700 : double.infinity,
          padding: EdgeInsets.all(18),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('welcome'.tr, style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 12),
                CustomTextField(controller: _email, label: 'Email'),
                SizedBox(height: 8),
                CustomTextField(controller: _pass, label: 'Parol', obscure: true),
                SizedBox(height: 12),
                Obx(() => auth.isLoading.value ? CircularProgressIndicator() : Column(children: [
                  CustomButton(label: 'Kirish', onTap: () => auth.login(_email.text.trim(), _pass.text.trim()), icon: Icons.login),
                  SizedBox(height: 8),
                  TextButton(onPressed: () => Get.toNamed(Routes.RESET), child: Text('Parolni tiklash'))
                ])),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Yangi foydalanuvchi? '),
                  TextButton(onPressed: () => Get.toNamed(Routes.REGISTER), child: Text('Ro\'yxatdan o\'tish'))
                ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
