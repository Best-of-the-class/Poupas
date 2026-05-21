import 'package:flutter/material.dart';

import '../../../../widgets/background.dart';
import '../../../../widgets/navigate_top_corner.dart';

import '../widgets/login_form.dart';

class LoginMobileLayout extends StatelessWidget {
  const LoginMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      position: ImagePosition.bottom,
      imageSize: 393,
      imagePath:
          'lib/core/assets/images/poup_bottom.png',
      child: const Padding(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigateTopCorner(route: 'welcome'),
            SizedBox(height: 12),
            Expanded(
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}