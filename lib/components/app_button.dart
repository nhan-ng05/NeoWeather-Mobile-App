import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Widget? icon;
  final Color? iconColor;
  final Color? foregroundColor;
  final Color? backgroundColor;
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon,
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        iconColor: iconColor,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
