import 'dart:math';

import 'package:flutter/material.dart';

class SnowIcon extends StatefulWidget {
  final double size;
  const SnowIcon({super.key, required this.size});

  @override
  State<SnowIcon> createState() => _SnowIconState();
}

class _SnowIconState extends State<SnowIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final List<double> flakes = List.generate(25, (_) => Random().nextDouble());

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
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
          return CustomPaint(painter: SnowPainter(flakes, controller.value));
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

class SnowPainter extends CustomPainter {
  final List<double> flakes;
  final double progress;

  SnowPainter(this.flakes, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    for (int i = 0; i < flakes.length; i++) {
      final baseX = flakes[i] * size.width;

      final x = baseX + sin(progress * 2 * pi + i) * 5;

      final y = (progress * size.height + i * 20) % size.height;

      canvas.drawCircle(Offset(x, y), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SnowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
