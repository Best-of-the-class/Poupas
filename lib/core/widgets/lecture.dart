import 'package:flutter/material.dart';
import 'module.dart';

class Lecture extends StatelessWidget {
  final String title;
  final IconData iconOne;
  final IconData iconTwo;
  final Module theme;

  const Lecture({
    super.key,
    required this.title,
    required this.iconOne,
    required this.iconTwo,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        border: Border.all(color: theme.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
          Container(
            width: 52,
            height: double.infinity,
            color: theme.iconOneBackgroundColor,
            child: Icon(iconOne, color: Colors.white, size: 24),
          ),
          Container(
            width: 52,
            height: double.infinity,
            color: theme.iconTwoBackgroundColor,
            child: Icon(iconTwo, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
