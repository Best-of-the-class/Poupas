import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import '../../../../widgets/profile_header.dart';
import '../../../../widgets/stats_section.dart';
import '../../../../widgets/profile_actions.dart';
import '../entities/user_profile_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileBloc>().loadProfile(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(child: ProfileContent());
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state.isLoading && !state.hasProfile) {
          return const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;

        if (profile == null) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.errorMessage ?? 'Não foi possível carregar o perfil.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  name: profile.name,
                  email: profile.email,
                  imagePath: avatarAssetForId(profile.avatarId),
                ),
                StatsSection(
                  completedLessons: profile.completedLessons,
                  solvedExercises: profile.solvedExercises,
                  xp: profile.xp,
                  streakDays: profile.streakDays,
                ),
                const ProfileActions(),
              ],
            ),
          ),
        );
      },
    );
  }
}
