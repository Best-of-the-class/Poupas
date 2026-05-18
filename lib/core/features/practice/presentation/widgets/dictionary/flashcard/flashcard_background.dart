import 'package:flutter/material.dart';

class FlashcardBackground extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const FlashcardBackground({
    super.key,
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }
}