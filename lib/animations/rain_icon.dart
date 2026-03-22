import 'dart:math';
import 'package:flutter/material.dart';

class RainIcon extends StatefulWidget {
  final double size;
  const RainIcon({super.key, required this.size});

  @override
  State<RainIcon> createState() => _RainIconState();
}

class _RainIconState extends State<RainIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final List<double> drops = List.generate(20, (_) => Random().nextDouble());

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                return CustomPaint(
                  painter: RainPainter(drops, controller.value),
                );
              },
            ),
          ),

          Positioned.fill(child: CustomPaint(painter: CloudPainter())),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, -size.height * 0.1);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.grey.shade300, Colors.grey.shade600],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.30,
        size.height * 0.56,
        size.width * 0.44,
        size.height * 0.11,
      ),
      paint,
    );

    // bubbles
    canvas.drawCircle(
      Offset(size.width * 0.32, size.height * 0.48),
      size.width * 0.18,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.42),
      size.width * 0.22,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.73, size.height * 0.5),
      size.width * 0.16,
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class RainPainter extends CustomPainter {
  final List<double> drops;
  final double progress;

  RainPainter(this.drops, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2.5;

    for (int i = 0; i < drops.length; i++) {
      // final x = drops[i] * size.width;
      final x = (drops[i] * size.width * 0.6) + size.width * 0.2;
      final startY = size.height * 0.32;

      final y =
          startY +
          ((progress * size.height * 0.7 + i * 15) % (size.height * 0.5));

      canvas.drawLine(Offset(x, y), Offset(x + 2, y + 12), paint);
    }
  }

  @override
  bool shouldRepaint(covariant RainPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
