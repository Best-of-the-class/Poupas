import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/widgets/badge_card.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileBloc>().loadProfile(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(child: BadgesContent());
  }
}

class BadgesContent extends StatelessWidget {
  const BadgesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        final badges = state.profile?.achievements ?? const [];

        if (state.isLoading && !state.hasProfile) {
          return const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Text(
                  'Conquistas',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 20,
                    color: AppColors.title,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'As conquistas abaixo refletem o progresso real do usuário autenticado.',
                  textAlign: TextAlign.justify,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                Expanded(
                  child: badges.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.workspace_premium_outlined,
                                size: 90,
                                color: AppColors.primary.withOpacity(0.3),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                state.errorMessage ??
                                    'Nenhuma conquista disponível para este usuário.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 16,
                                  color: AppColors.textDark,
                                ),
                              ),

                              const SizedBox(height: 40),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.only(bottom: 120),
                          itemCount: badges.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            final badge = badges[index];

                            return BadgeCard(
                              titulo: badge.title,
                              descricao: badge.description,
                              iconName: badge.iconName,
                              backgroundColorKey: badge.backgroundColorKey,
                              isUnlocked: badge.isUnlocked,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
