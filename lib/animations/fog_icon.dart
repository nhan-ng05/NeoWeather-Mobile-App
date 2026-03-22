import 'dart:math';

import 'package:flutter/material.dart';

class FogIcon extends StatefulWidget {
  final double size;
  const FogIcon({super.key, required this.size});

  @override
  State<FogIcon> createState() => _FogIconState();
}

class _FogIconState extends State<FogIcon> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(painter: FogPainter(controller.value));
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class FogPainter extends CustomPainter {
  final double progress;

  FogPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.4 + i * 0.12);

      final offsetX = sin(progress * pi * 2 + i) * 10;

      canvas.drawLine(
        Offset(20 + offsetX, y),
        Offset(size.width - 20 + offsetX, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FogPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
