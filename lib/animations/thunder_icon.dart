import 'package:flutter/material.dart';

class ThunderIcon extends StatefulWidget {
  final double size;
  const ThunderIcon({super.key, required this.size});

  @override
  State<ThunderIcon> createState() => _ThunderIconState();
}

class _ThunderIconState extends State<ThunderIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.cloud, size: widget.size, color: Colors.grey),

          Positioned(
            bottom: 5,
            child: FadeTransition(
              opacity: controller,
              child: Icon(
                Icons.flash_on,
                size: widget.size * 0.5,
                color: Colors.yellow.shade300,
              ),
            ),
          ),
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
