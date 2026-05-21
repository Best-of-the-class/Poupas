import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class MissingQuestion extends StatelessWidget {
  final Color themeColor;
  final VoidCallback? onTap;

  const MissingQuestion({super.key, required this.themeColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: themeColor,
            strokeWidth: 2,
            dashPattern: const [8, 4],
            radius: const Radius.circular(20),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
