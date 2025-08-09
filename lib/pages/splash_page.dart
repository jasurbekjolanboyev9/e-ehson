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
    Timer(Duration(milliseconds: 800), () => Get.offNamed(Routes.LOGIN));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      FlutterLogo(size: 96),
      SizedBox(height: 12),
      Text('e-Ehson', style: Theme.of(context).textTheme.headlineSmall),
      SizedBox(height: 6),
      Text('Shaffof va ishonchli ehson platformasi', textAlign: TextAlign.center),
    ])));
  }
}
