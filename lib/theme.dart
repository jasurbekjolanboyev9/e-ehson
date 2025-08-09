import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cardTheme: const CardThemeData(
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );
}
