import 'package:flutter/material.dart';

class Choice extends StatelessWidget {
  final String letter;
  final TextEditingController controller;
  final bool isSelected;
  final bool isCorrect;
  final Color themeColor;
  final VoidCallback onSelected;

  const Choice({
    super.key,
    required this.letter,
    required this.controller,
    required this.isSelected,
    required this.isCorrect,
    required this.themeColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EEDA),
        border: Border.all(
          color: isCorrect ? themeColor : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFCC99),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Alternativa...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: onSelected,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
                color: isSelected
                    ? Colors.green.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.green)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
