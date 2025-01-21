import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String label;

  const Label({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }
}
