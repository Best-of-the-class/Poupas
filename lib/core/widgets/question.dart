import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color themeColor;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const Question({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.themeColor = const Color(0xFF2E7D32),
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.5),
        border: Border.all(color: themeColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: themeColor.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) => onToggle?.call(),
                          activeColor: themeColor,
                          checkColor: Colors.white,
                          side: BorderSide(color: themeColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 60,
              height: double.infinity,
              color: themeColor,
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
