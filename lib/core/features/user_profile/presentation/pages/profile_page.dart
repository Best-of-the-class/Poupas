import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import '../../../../widgets/profile_header.dart';
import '../../../../widgets/stats_section.dart';
import '../../../../widgets/profile_actions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      child: ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              name: "Nome Usuário",
              email: "nomeusuario@email.com",
              imagePath:
                  "lib/core/features/user_profile/presentation/assets/images/avatar_1.png",
            ),
            StatsSection(),
            ProfileActions(),
          ],
        ),
      ),
    );
  }
}