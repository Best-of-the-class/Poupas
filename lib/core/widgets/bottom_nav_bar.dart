import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go(
          '/practice-intro',
        ); 
        break;
      case 2:
        context.go(
          '/badges',
        ); 
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
    child: Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(30),
      color: AppColors.perfilSequencia,
      child: Container(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(context, 0, Icons.home_outlined),
            _buildItem(context, 1, Icons.menu_book_outlined),
            _buildItem(context, 2, Icons.workspace_premium_outlined),
            _buildItem(context, 3, Icons.person_outlined),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              size: 40,
              color: isActive ? AppColors.textLight : AppColors.primary,
            ),
          ),

          if (isActive)
            Positioned(
              top: -12,
              left: 8,
              child: Image.asset(
                'lib/core/assets/images/folha-icon-active-menu.png',
                width: 18,
                height: 18,
              ),
            ),
        ],
      ),
    );
  }
}
