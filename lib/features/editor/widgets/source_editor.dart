import 'package:flutter/material.dart';

class SourceEditor extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;

  const SourceEditor({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        height: 1.6,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
        filled: false,
        hintText: 'Start writing markdown...',
        hintStyle: TextStyle(
          fontFamily: 'monospace',
          color: isDark ? Colors.white30 : Colors.black26,
        ),
      ),
      keyboardType: TextInputType.multiline,
    );
  }
}
