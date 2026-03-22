import 'package:flutter/material.dart';

class SunIcon extends StatefulWidget {
  final double size;
  const SunIcon({super.key, required this.size});

  @override
  State<SunIcon> createState() => _SunIconState();
}

class _SunIconState extends State<SunIcon> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: controller,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(Icons.wb_sunny, size: widget.size, color: Colors.orange),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
