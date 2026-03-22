import 'dart:math';

import 'package:flutter/material.dart';

class CloudIcon extends StatefulWidget {
  final double size;
  final bool isNight;

  const CloudIcon({super.key, required this.size, this.isNight = false});

  @override
  State<CloudIcon> createState() => _CloudIconState();
}

class _CloudIconState extends State<CloudIcon>
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
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(sin(controller.value * 2 * pi) * 10, 0),
          child: Icon(
            Icons.cloud,
            size: widget.size,
            color: widget.isNight
                ? Colors.blueGrey.shade600
                : Colors.lightBlue.shade300,
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
