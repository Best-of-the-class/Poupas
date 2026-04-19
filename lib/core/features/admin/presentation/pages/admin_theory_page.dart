import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/input.dart';
import '../../../../widgets/custom_editor.dart';
import '../../../../widgets/pop_up.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../network/adapters/routes_adapter.dart';
import '../../../../widgets/module.dart';
import '../bloc/navigator_bloc.dart';
import '../bloc/question_bloc.dart';

class AdminTheory extends StatefulWidget {
  final ModuleDifficulty difficulty;
  const AdminTheory({super.key, required this.difficulty});

  @override
  State<AdminTheory> createState() => _AdminTheoryState();
}

class _AdminTheoryState extends State<AdminTheory> {
  final Color themeColor = const Color(0xFFE32626);
  final GlobalKey<CustomEditorState> _editorKey =
      GlobalKey<CustomEditorState>();
  String _currentTitle = '';

  Future<void> _showErrorPopup(BuildContext context, String message) async {
    final navBloc = context.read<AdminNavigationBloc>();
    if (navBloc.isDialogOpen) return;
    navBloc.isDialogOpen = true;

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: PopUp(
            title: 'Ops!',
            subtitle: message,
            buttons: [
              WideButton(
                text: 'Tentar novamente',
                onPress: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );

    navBloc.isDialogOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: BlocListener<AdminNavigationBloc, AdminNavigationState>(
        listenWhen: (prev, curr) {
          if (curr is AdminErrorEffect && prev is AdminErrorEffect)
            return curr.id != prev.id;
          if (curr is AdminNavSideEffect && prev is AdminNavSideEffect)
            return curr.id != prev.id;
          return true;
        },
        listener: (context, state) {
          if (state is AdminErrorEffect) {
            _showErrorPopup(context, state.message);
          } else if (state is AdminNavSideEffect) {
            AdminQuestionsBloc.setTempTitle(_currentTitle);
            context.pushNamed(
              RoutesAdapter.adminQuestions,
              extra: widget.difficulty,
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Vamos começar com a teoria',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final content =
                            _editorKey.currentState?.controller.document
                                .toPlainText() ??
                            '';
                        context.read<AdminNavigationBloc>().validateAndCreate(
                          _currentTitle,
                          content,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Próximo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Input(
                  hint: 'Adicione um título para a aula',
                  onChanged: (val) => _currentTitle = val,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: CustomEditor(key: _editorKey, themeColor: themeColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
