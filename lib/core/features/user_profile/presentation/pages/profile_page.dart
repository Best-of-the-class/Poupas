import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/profile_bloc.dart';
import '../../../../../services/current_user_service.dart';
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

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final CurrentUserService _currentUser = CurrentUserService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = _currentUser.email;
      if (email != null && email.isNotEmpty) {
        context.read<ProfileBloc>().add(LoadProfile(email));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  name: profile?.nomeUsuario ?? "Nome Usuário",
                  email: profile?.email ?? "nomeusuario@email.com",
                  imagePath:
                      "lib/core/features/user_profile/presentation/assets/images/avatar_1.png",
                ),
                StatsSection(
                  key: ValueKey(
                    '${profile?.email ?? 'default'}-${profile?.pontuacao ?? 2584}-${profile?.licoesConcluidas ?? 20}-${profile?.exerciciosResolvidos ?? 35}-${profile?.sequenciaDias ?? 14}',
                  ),
                  licoesConcluidas: profile?.licoesConcluidas ?? 20,
                  exerciciosResolvidos: profile?.exerciciosResolvidos ?? 35,
                  pontuacao: profile?.pontuacao ?? 2584,
                  sequenciaDias: profile?.sequenciaDias ?? 14,
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
