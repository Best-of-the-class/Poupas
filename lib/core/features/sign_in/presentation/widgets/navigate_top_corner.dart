import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigateTopCorner extends StatelessWidget {
  final String route;
  final IconData icon;
  final Map<String, String> params;
  final Color color;

  const NavigateTopCorner({
    super.key,
    required this.route,
    this.icon = Icons.arrow_back,
    this.params = const {},
    this.color = const Color(0xFF212121),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.centerLeft,
      icon: Icon(icon, color: color, size: 28),
      onPressed: () {
        context.pushNamed(route, pathParameters: params);
      },
    );
  }
}
