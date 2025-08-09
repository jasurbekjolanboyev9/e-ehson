import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outline;
  final IconData? icon;

  const CustomButton({required this.label, required this.onTap, this.outline = false, this.icon});

  @override
  Widget build(BuildContext context) {
    if (outline) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: icon != null ? Icon(icon) : SizedBox.shrink(),
        label: Text(label),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: icon != null ? Icon(icon) : SizedBox.shrink(),
      label: Text(label),
    );
  }
}
