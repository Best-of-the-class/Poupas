import 'package:flutter_bloc/flutter_bloc.dart';
import '../entities/question_item.dart';

abstract class AdminQuestionsEvent {}

class LoadQuestionsByLesson extends AdminQuestionsEvent {
  final String lessonTitle;
  LoadQuestionsByLesson(this.lessonTitle);
}

class LoadQuestionForView extends AdminQuestionsEvent {
  final int index;
  LoadQuestionForView(this.index);
}

class SaveQuestion extends AdminQuestionsEvent {
  final String questionText;
  final List<String> choices;
  final int correctIndex;
  SaveQuestion({
    required this.questionText,
    required this.choices,
    required this.correctIndex,
  });
}

class UpdateQuestion extends AdminQuestionsEvent {
  final int index;
  final String questionText;
  final List<String> choices;
  final int correctIndex;
  UpdateQuestion({
    required this.index,
    required this.questionText,
    required this.choices,
    required this.correctIndex,
  });
}

class DeleteQuestion extends AdminQuestionsEvent {
  final int index;
  DeleteQuestion(this.index);
}

class ToggleQuestionSelection extends AdminQuestionsEvent {
  final int index;
  ToggleQuestionSelection(this.index);
}

class ClearSelection extends AdminQuestionsEvent {}

class ResetQuestions extends AdminQuestionsEvent {}

class AdminQuestionsState {
  final List<QuestionItem> questions;
  final int? viewingIndex;
  final String? errorMessage;
  final int errorId;

  const AdminQuestionsState({
    this.questions = const [],
    this.viewingIndex,
    this.errorMessage,
    this.errorId = 0,
  });

  AdminQuestionsState copyWith({
    List<QuestionItem>? questions,
    int? viewingIndex,
    bool resetView = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AdminQuestionsState(
      questions: questions ?? this.questions,
      viewingIndex: resetView ? null : (viewingIndex ?? this.viewingIndex),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorId: errorMessage != null
          ? DateTime.now().microsecondsSinceEpoch
          : this.errorId,
    );
  }
}

class AdminQuestionsBloc
    extends Bloc<AdminQuestionsEvent, AdminQuestionsState> {
  static final Set<String> _defaultLessons = {
    'Juros Composto',
    'Capital de Giro',
    'Equivalência de Capitais',
  };

  static final Map<String, List<QuestionItem>> _store = {
    'Juros Composto': _generateDefaultQuestions(),
    'Capital de Giro': _generateDefaultQuestions(),
    'Equivalência de Capitais': _generateDefaultQuestions(),
  };

  static String? _tempLessonTitle;
  String? _currentLesson;

  AdminQuestionsBloc() : super(const AdminQuestionsState()) {
    on<LoadQuestionsByLesson>(_onLoad);
    on<LoadQuestionForView>(_onLoadForView);
    on<ClearSelection>(_onClearSelection);
    on<SaveQuestion>(_onSave);
    on<UpdateQuestion>(_onUpdate);
    on<DeleteQuestion>(_onDelete);
    on<ToggleQuestionSelection>(_onToggle);
    on<ResetQuestions>(_onReset);
  }

  static List<QuestionItem> _generateDefaultQuestions() {
    return List.generate(
      4,
      (i) => QuestionItem(
        title: 'Questão ${i + 1}',
        subtitle: 'Adicionar questão na prova final',
        questionText: 'Texto da questão ${i + 1} para o módulo padrão.',
        choices: ['Alternativa A', 'Alternativa B', 'Alternativa C'],
        correctIndex: 0,
        isSelected: false,
      ),
    );
  }

  bool _isInvalid(String text, List<String> choices) {
    if (text.trim().isEmpty) return true;
    if (choices.any((c) => c.trim().isEmpty)) return true;
    return false;
  }

  void _persist(List<QuestionItem> questions) {
    if (_currentLesson != null) {
      _store[_currentLesson!] = List.from(questions);
    }
  }

  List<QuestionItem> _stored() => List.from(_store[_currentLesson ?? ''] ?? []);

  void _onReset(ResetQuestions event, Emitter<AdminQuestionsState> emit) {
    _currentLesson = null;
    emit(const AdminQuestionsState());
  }

  void _onLoad(LoadQuestionsByLesson event, Emitter<AdminQuestionsState> emit) {
    _currentLesson = event.lessonTitle;
    emit(
      state.copyWith(questions: _stored(), resetView: true, clearError: true),
    );
  }

  void _onLoadForView(
    LoadQuestionForView event,
    Emitter<AdminQuestionsState> emit,
  ) {
    emit(state.copyWith(viewingIndex: event.index, clearError: true));
  }

  void _onClearSelection(
    ClearSelection event,
    Emitter<AdminQuestionsState> emit,
  ) {
    emit(state.copyWith(resetView: true, clearError: true));
  }

  void _onSave(SaveQuestion event, Emitter<AdminQuestionsState> emit) {
    if (_isInvalid(event.questionText, event.choices)) {
      emit(
        state.copyWith(
          errorMessage: 'Preencha a pergunta e todas as alternativas',
        ),
      );
      return;
    }
    final updated = List<QuestionItem>.from(state.questions);
    if (updated.length >= 4) return;
    updated.add(
      QuestionItem(
        title: 'Questão ${updated.length + 1} criada!',
        subtitle: 'Adicionar questão na prova final',
        questionText: event.questionText,
        choices: event.choices,
        correctIndex: event.correctIndex,
        isSelected: false,
      ),
    );
    _persist(updated);
    emit(state.copyWith(questions: updated, resetView: true, clearError: true));
  }

  void _onUpdate(UpdateQuestion event, Emitter<AdminQuestionsState> emit) {
    if (event.index < 0 || event.index >= state.questions.length) return;
    if (_isInvalid(event.questionText, event.choices)) {
      emit(
        state.copyWith(
          errorMessage: 'Campos vazios não são permitidos na edição',
        ),
      );
      return;
    }
    final updated = List<QuestionItem>.from(state.questions);
    updated[event.index] = updated[event.index].copyWith(
      questionText: event.questionText,
      choices: event.choices,
      correctIndex: event.correctIndex,
    );
    _persist(updated);
    emit(state.copyWith(questions: updated, clearError: true));
  }

  void _onDelete(DeleteQuestion event, Emitter<AdminQuestionsState> emit) {
    if (event.index < 0 || event.index >= state.questions.length) return;
    final updated = List<QuestionItem>.from(state.questions)
      ..removeAt(event.index);
    _persist(updated);
    emit(state.copyWith(questions: updated, resetView: true, clearError: true));
  }

  void _onToggle(
    ToggleQuestionSelection event,
    Emitter<AdminQuestionsState> emit,
  ) {
    if (event.index < 0 || event.index >= state.questions.length) return;
    final updated = List<QuestionItem>.from(state.questions);
    updated[event.index] = updated[event.index].copyWith(
      isSelected: !updated[event.index].isSelected,
    );
    _persist(updated);
    emit(state.copyWith(questions: updated, clearError: true));
  }

  static void persistForLesson(
    String lessonTitle,
    List<QuestionItem> questions,
  ) {
    _store[lessonTitle] = List.from(questions);
  }

  static bool isDefaultLesson(String title) => _defaultLessons.contains(title);

  static void setTempTitle(String title) => _tempLessonTitle = title;
  static String? get tempTitle => _tempLessonTitle;
}
