import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/widgets/bottom_nav_bar.dart';

import 'package:pomo/core/theme/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  int _getIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/book')) return 1;
    if (location.startsWith('/achievements')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: _getIndex(location),
            ),
          ),
        ],
      ),
    );
  }
}