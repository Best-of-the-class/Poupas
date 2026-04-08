import 'package:flutter/material.dart';
import 'background.dart';

class LoadingBackground extends StatefulWidget {
  final String imagePath;
  final String loadingText;
  final Color color;

  const LoadingBackground({
    super.key,
    required this.imagePath,
    this.loadingText = "moedas",
    this.color = const Color(0xFFFDF5E6),
  });

  @override
  State<LoadingBackground> createState() => _LoadingBackgroundState();
}

class _LoadingBackgroundState extends State<LoadingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuad,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      position: ImagePosition.center,
      color: widget.color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -20 * _animation.value),
                  child: Transform.scale(
                    scaleY: 1.0 - (0.1 * _animation.value),
                    child: Image.asset(
                      widget.imagePath,
                      width: 100,
                      height: 100,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            Text(
              "Carregando ${widget.loadingText}...",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
