import 'package:flutter/material.dart';

class MoonIcon extends StatefulWidget {
  final double size;
  const MoonIcon({super.key, required this.size});

  @override
  State<MoonIcon> createState() => _MoonIconState();
}

class _MoonIconState extends State<MoonIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, controller.value * 5), // trôi nhẹ lên xuống
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(
                    0.5 + controller.value * 0.3,
                  ),
                  blurRadius: 15 + controller.value * 10,
                ),
              ],
            ),
            child: Icon(
              Icons.nightlight_round,
              size: widget.size,
              color: Colors.indigo,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
