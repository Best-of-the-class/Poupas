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
import '../bloc/lesson_bloc.dart';
import '../../../../widgets/navigate_top_corner.dart';

class AdminTheory extends StatefulWidget {
  final ModuleDifficulty difficulty;
  final String? editLessonTitle;

  const AdminTheory({
    super.key, 
    required this.difficulty, 
    this.editLessonTitle,
  });

  @override
  State<AdminTheory> createState() => _AdminTheoryState();
}

class _AdminTheoryState extends State<AdminTheory> {
  final Color themeColor = const Color(0xFFE32626);
  final GlobalKey<CustomEditorState> _editorKey = GlobalKey<CustomEditorState>();
  
  final TextEditingController _titleController = TextEditingController();
  String _currentTitle = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.editLessonTitle != null) {
      _currentTitle = widget.editLessonTitle!;
      _titleController.text = _currentTitle;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LessonBloc>().add(LoadLessonDetails(widget.editLessonTitle!));
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<LessonBloc, LessonState>(
            listenWhen: (prev, curr) => prev.lessonDetails != curr.lessonDetails,
            listener: (context, state) {
              if (state.lessonDetails != null && widget.editLessonTitle != null) {
                final details = state.lessonDetails!;
                setState(() {
                  _titleController.text = details['tituloLicao'] ?? '';
                  _currentTitle = _titleController.text;
                });
                
                Future.delayed(const Duration(milliseconds: 100), () {
                  _editorKey.currentState?.setContent(details['textoConceito'] ?? '');
                });
              }
            },
          ),
          BlocListener<AdminNavigationBloc, AdminNavigationState>(
            listenWhen: (prev, curr) {
              if (curr is AdminErrorEffect && prev is AdminErrorEffect) {
                return curr.id != prev.id;
              }
              if (curr is AdminNavSideEffect && prev is AdminNavSideEffect) {
                return curr.id != prev.id;
              }
              return true;
            },
            listener: (context, state) {
              if (state is AdminErrorEffect) {
                _showErrorPopup(context, state.message);
              } else if (state is AdminNavSideEffect) {
                final content = _editorKey.currentState?.controller.document.toPlainText() ?? '';
                AdminQuestionsBloc.setTempData(_currentTitle, content); 

                if (widget.editLessonTitle != null) {
                  context.pushNamed(
                    RoutesAdapter.adminEditQuestions,
                    extra: widget.editLessonTitle, 
                  );
                } else {
                  context.pushNamed(
                    RoutesAdapter.adminQuestions,
                    extra: widget.difficulty,
                  );
                }
              }
            },
          ),
        ],
        child: SafeArea(
          child: BlocBuilder<LessonBloc, LessonState>(
            builder: (context, lessonState) {
              if (lessonState.isLoading && widget.editLessonTitle != null && lessonState.lessonDetails == null) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFE32626)));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20),
                        const NavigateTopCorner(),
                        Text(
                          widget.editLessonTitle != null 
                              ? 'Editando a teoria' 
                              : 'Vamos começar com a teoria',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final content = _editorKey.currentState?.controller.document.toPlainText() ?? '';
                            context.read<AdminNavigationBloc>().validateAndCreate(
                              _currentTitle,
                              content,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                      controller: _titleController,
                      onChanged: (val) => _currentTitle = val,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: CustomEditor(key: _editorKey, themeColor: themeColor),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}