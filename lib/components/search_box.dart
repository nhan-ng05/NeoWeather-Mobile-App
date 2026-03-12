import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextStyle? style;
  final bool readOnly;
  final InputDecoration? decoration;
  final TextAlign textAlign;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  const SearchBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.style,
    required this.readOnly,
    required this.decoration,
    required this.textAlign,
    required this.obscureText,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: textAlign,
      controller: controller,
      focusNode: focusNode,
      style: style,
      readOnly: readOnly,
      decoration: decoration,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
    );
  }
}
