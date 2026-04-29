import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/theme/app_colors.dart';

class NavigateTopCorner extends StatelessWidget {
  final String? route;
  final IconData icon;
  final Map<String, String> params;
  final Color color;

  const NavigateTopCorner({
    super.key,
    this.route,
    this.icon = Icons.arrow_back,
    this.params = const {},
    this.color = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.centerLeft,
      icon: Icon(icon, color: color, size: 28),
      onPressed: () {
        if (context.canPop()) {
          context.pop(); // volta tela anterior
        } else if (route != null) {
          context.goNamed(route!, pathParameters: params);
        }
      },
    );
  }
}