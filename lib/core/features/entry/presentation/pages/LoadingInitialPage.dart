import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingWelcomePage extends StatefulWidget {
  const LoadingWelcomePage({super.key});

  @override
  State<LoadingWelcomePage> createState() => _LoadingWelcomePageState();
}

class _LoadingWelcomePageState extends State<LoadingWelcomePage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/welcome');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE52727),
      body: Stack(
        children: [

          /// 👓 ÓCULOS (centro um pouco acima)
          Align(
            alignment: const Alignment(0, -0.2), // 👈 sobe um pouco
            child: Image.asset(
              'lib/core/features/entry/presentation/assets/image/oculos.png',
              width: 350,
            ),
          ),

          /// 👋 OI (embaixo à direita com animação)
          Positioned(
            bottom: 120,
            right: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value), // 👈 sobe/desce
                  child: child,
                );
              },
              child: Image.asset(
                'lib/core/features/entry/presentation/assets/image/oi.png',
                width: 220,
              ),
            ),
          ),
        ],
      ),
    );
  }
}