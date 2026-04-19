import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';

class CustomPositionedImage extends StatelessWidget {
  final Widget child;
  final String? imagePath;
  final double imageSize;
  final Color? color;
  final double posX;
  final double posY;

  const CustomPositionedImage({
    super.key,
    required this.child,
    this.imagePath,
    this.imageSize = 226.0,
    this.color,
    this.posX = 109.0,
    this.posY = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: color ?? AppColors.background,
      body: Stack(
        children: [
          if (imagePath != null)
            Positioned(
              left: posX,
              top: posY,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: keyboardIsOpen ? 0.2 : 1.0,
                child: Image.asset(
                  imagePath!,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          SafeArea(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
