import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:go_router/go_router.dart';
import '../bloc/lesson_bloc.dart';
import '../../../../network/adapters/routes_adapter.dart';
import '../../../../widgets/module.dart';
import '../../../../widgets/module_group.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../widgets/pop_up.dart';

class AdminActivities extends StatefulWidget {
  const AdminActivities({super.key});

  @override
  State<AdminActivities> createState() => _AdminActivitiesState();
}

class _AdminActivitiesState extends State<AdminActivities> {
  @override
  void initState() {
    super.initState();
    _setupWindow();
  }

  void _setupWindow() async {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1366, 768),
      minimumSize: Size(1366, 768),
      maximumSize: Size(1366, 768),
      center: true,
      title: 'Poupas Admin',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
              child: Row(
                children: [
                  const Text(
                    'Boa Tarde, Admin!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(width: 24),
                  WideButton(
                    text: 'Dicionário',
                    backgroundColor: const Color(0xFF4285F4),
                    onPress: () {},
                  ),
                  const Spacer(),
                  WideButton(
                    text: 'Logout',
                    backgroundColor: const Color(0xFFE32626),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPress: () async {
                      await windowManager.setResizable(true);
                      await windowManager.setMinimumSize(Size.zero);
                      await windowManager.setMaximumSize(const Size(-1, -1));
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: BlocBuilder<LessonBloc, LessonState>(
                  builder: (context, state) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (
                          int i = 0;
                          i < ModuleDifficulty.values.length;
                          i++
                        ) ...[
                          Expanded(
                            child: ModuleGroup(
                              difficulty: ModuleDifficulty.values[i],
                              lessonTitles:
                                  state.lessonsByDifficulty[ModuleDifficulty
                                      .values[i]] ??
                                  [],
                              actionButtonTitle: 'Criar aula nesse módulo',
                              actionButtonIcon: Icons.add,
                              onActionButtonTap: () {
                                context.pushNamed(
                                  'adminTheory',
                                  extra: ModuleDifficulty.values[i],
                                );
                              },
                              onEdit: (index) {
                                final lessonTitle =
                                    (state.lessonsByDifficulty[ModuleDifficulty
                                        .values[i]] ??
                                    [])[index];
                                context.pushNamed(
                                  RoutesAdapter.adminEditQuestions,
                                  extra: lessonTitle,
                                );
                              },
                              onDelete: (index) {
                                final difficulty = ModuleDifficulty.values[i];

                                final lessonTitle =
                                    (state.lessonsByDifficulty[difficulty] ?? [])[index];

                                PopUp.show(
                                  context,
                                  title: 'Excluir aula',
                                  subtitle:
                                      'Deseja realmente excluir "$lessonTitle"? Essa ação não poderá ser desfeita.',
                                  buttons: [
                                    WideButton(
                                      text: 'Cancelar',
                                      onPress: () {
                                        Navigator.pop(context);
                                      },
                                    ),

                                    WideButton(
                                      text: 'Excluir',
                                      backgroundColor: Colors.transparent,
                                      textColor: Colors.red,
                                      borderColor: Colors.red,
                                      onPress: () {
                                        Navigator.pop(context);

                                        context.read<LessonBloc>().add(
                                          DeleteLesson(
                                            difficulty,
                                            index,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          if (i < ModuleDifficulty.values.length - 1)
                            const SizedBox(width: 32),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
