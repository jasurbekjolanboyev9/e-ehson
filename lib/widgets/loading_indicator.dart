import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  const LoadingIndicator({this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: CircularProgressIndicator());
  }
}
