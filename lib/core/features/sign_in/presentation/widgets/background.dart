import 'package:flutter/material.dart';

enum ImagePosition { top, center, bottom }

class Background extends StatelessWidget {
  final Widget child;
  final String? imagePath;
  final ImagePosition position;
  final double imageSize;
  final Color color;

  const Background({
    super.key,
    required this.child,
    this.imagePath,
    this.position = ImagePosition.top,
    this.imageSize = 200.0,
    this.color = const Color(0xFFFDF5E6),
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: color,
      body: Stack(
        children: [
          if (imagePath != null)
            Positioned(
              top: position == ImagePosition.bottom ? null : _calculateTop(size.height),
              bottom: position == ImagePosition.bottom ? 0 : null,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: keyboardIsOpen ? 0.2 : 1.0,
                child: Image.asset(
                  imagePath!,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
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

  double? _calculateTop(double windowSize) {
    switch (position) {
      case ImagePosition.top:
        return 0;
      case ImagePosition.center:
        return (windowSize / 2) - (imageSize / 2);
      case ImagePosition.bottom:
        return null;
    }
  }
}