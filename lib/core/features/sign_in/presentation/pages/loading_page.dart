import 'package:flutter/material.dart';
import '../../../../widgets/loading.dart';

class LoadingPage extends StatelessWidget {
  final String text;
  final String imagePath;
  final Color backgroundColor;

  const LoadingPage({
    super.key, 
    this.text = "maçãs", 
    this.imagePath = 'lib/core/features/sign_in/presentation/assets/images/poup_caterpillar.png',
    this.backgroundColor = const Color(0xFFF7EEDD),
  });

  @override
  Widget build(BuildContext context) {
    return LoadingBackground(
      imagePath: imagePath,
      loadingText: text,
      color: backgroundColor,
    );
  }
}