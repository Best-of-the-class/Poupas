import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/widgets/card_stats_home.dart';
import 'package:pomo/core/widgets/card_module.dart';
import 'package:pomo/core/widgets/trail_module.dart';
import 'package:pomo/core/features/admin/presentation/bloc/lesson_bloc.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/user_profile_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonBloc>().add(LoadLessons());
      context.read<UserProfileBloc>().loadProfile(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainLayout(child: HomeContent());
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'lib/core/assets/images/background-arvore-trilha.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<LessonBloc, LessonState>(
            builder: (context, state) {
              final profile = context.watch<UserProfileBloc>().state.profile;

              if (state.isLoading &&
                  state.lessonsByDifficulty.values.every((l) => l.isEmpty)) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final List<Map<String, dynamic>> dynamicLessons = [];
              int globalOrder = 1;
              int levelCounter = 1;

              for (var entry in state.lessonsByDifficulty.entries) {
                for (var titulo in entry.value) {
                  dynamicLessons.add({
                    'ordem': globalOrder++,
                    'titulo': titulo,
                    'level': levelCounter,
                    'isProva': false,
                  });
                }

                if (entry.value.isNotEmpty) {
                  dynamicLessons.add({
                    'ordem': globalOrder++,
                    'titulo': 'Prova Final - Módulo $levelCounter',
                    'level': levelCounter,
                    'isProva': true,
                  });
                }
                levelCounter++;
              }

              final modulosAtivos = [1, 2, 3];

              return Column(
                children: [
                  CardStatsHome(
                    sequenciaDias: profile?.streakDays ?? 0,
                    xp: profile?.xp ?? 0,
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...modulosAtivos.map((level) {
                            final lessonsDoModulo = dynamicLessons
                                .where((l) => l['level'] == level)
                                .toList();

                            if (lessonsDoModulo.isEmpty)
                              return const SizedBox.shrink();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardModule(level: level),
                                const SizedBox(height: 10),
                                TrailModule(
                                  lessons: lessonsDoModulo,
                                  progressoAtual:
                                      (profile?.completedLessons ?? 0) + 1,
                                ),
                                const SizedBox(height: 40),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
