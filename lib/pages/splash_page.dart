import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../routes.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // 800ms keyin login sahifasiga o‘tish
    Timer(Duration(milliseconds: 2000), () => Get.offNamed(Routes.LOGIN));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // FlutterLogo o‘rniga o‘z rasm logoni ishlatamiz
            Image.asset(
              'assets/images/app_icon.png', // Splash rasm yo‘li
              width: 200,
              height: 200,
            ),
            SizedBox(height: 12),
            Text(
              'e-Ehson',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 6),
            Text(
              'Shaffof va ishonchli ehson platformasi',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
