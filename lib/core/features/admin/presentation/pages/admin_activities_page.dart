import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:go_router/go_router.dart';
import '../../../../network/adapters/routes_adapter.dart';
import '../../../../widgets/module.dart';
import '../../../../widgets/module_group.dart';
import '../../../../widgets/wide_button.dart';

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
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1366, 768),
      minimumSize: Size(1366, 768),
      maximumSize: Size(1366, 768),
      center: true,
      title: "Poupas Admin",
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Back vai ter que encaminhar as aulas, nn fazer isso aqui e sim por um módulo para dps importar aqui pls a página é burra
    final List<String> aulas = [
      'Juros Composto',
      'Capital de Giro',
      'Equivalência de Capitais',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
              child: Row(
                children: [
                  // Modificar aqui se necessário pegar o nome do admin tbm
                  const Text(
                    "Boa Tarde, Admin!",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(width: 24),
                  WideButton(
                    text: "Dicionário",
                    backgroundColor: const Color(0xFF4285F4),
                    onPress: () {},
                  ),
                  const Spacer(),
                  WideButton(
                    text: "Logout",
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
                child: Row(
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
                              aulas, // Modificar o for para alternar o que vem do banco
                          actionButtonTitle: "Criar aula nesse módulo",
                          actionButtonIcon: Icons.add,
                          onActionButtonTap: () {
                            context.pushNamed(RoutesAdapter.adminQuestions);
                          },
                        ),
                      ),
                      if (i < ModuleDifficulty.values.length - 1)
                        const SizedBox(width: 32),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
