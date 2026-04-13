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

class AdminQuestionsState {
  final List<QuestionItem> questions;
  final int? viewingIndex;

  const AdminQuestionsState({this.questions = const [], this.viewingIndex});

  AdminQuestionsState copyWith({
    List<QuestionItem>? questions,
    int? viewingIndex,
    bool resetView = false,
  }) {
    return AdminQuestionsState(
      questions: questions ?? this.questions,
      viewingIndex: resetView ? null : (viewingIndex ?? this.viewingIndex),
    );
  }
}

class AdminQuestionsBloc
    extends Bloc<AdminQuestionsEvent, AdminQuestionsState> {
  static final Map<String, List<QuestionItem>> _store = {};

  String? _currentLesson;

  AdminQuestionsBloc() : super(const AdminQuestionsState()) {
    on<LoadQuestionsByLesson>(_onLoad);
    on<LoadQuestionForView>(_onLoadForView);
    on<ClearSelection>(_onClearSelection);
    on<SaveQuestion>(_onSave);
    on<UpdateQuestion>(_onUpdate);
    on<DeleteQuestion>(_onDelete);
    on<ToggleQuestionSelection>(_onToggle);
  }

  void _persist(List<QuestionItem> questions) {
    if (_currentLesson != null) {
      _store[_currentLesson!] = List.from(questions);
    }
  }

  List<QuestionItem> _stored() => List.from(_store[_currentLesson ?? ''] ?? []);

  void _onLoad(LoadQuestionsByLesson event, Emitter<AdminQuestionsState> emit) {
    _currentLesson = event.lessonTitle;
    emit(state.copyWith(questions: _stored(), resetView: true));
  }

  void _onLoadForView(
    LoadQuestionForView event,
    Emitter<AdminQuestionsState> emit,
  ) {
    emit(state.copyWith(viewingIndex: event.index));
  }

  void _onClearSelection(
    ClearSelection event,
    Emitter<AdminQuestionsState> emit,
  ) {
    emit(state.copyWith(resetView: true));
  }

  void _onSave(SaveQuestion event, Emitter<AdminQuestionsState> emit) {
    final updated = List<QuestionItem>.from(state.questions);
    if (updated.length >= 4) return;

    updated.add(
      QuestionItem(
        title: 'Questão ${updated.length + 1} criada!',
        subtitle: 'Adicionar questão na prova?',
        questionText: event.questionText,
        choices: event.choices,
        correctIndex: event.correctIndex,
      ),
    );

    _persist(updated);
    emit(state.copyWith(questions: updated, resetView: true));
  }

  void _onUpdate(UpdateQuestion event, Emitter<AdminQuestionsState> emit) {
    if (event.index < 0 || event.index >= state.questions.length) return;

    final updated = List<QuestionItem>.from(state.questions);
    updated[event.index] = updated[event.index].copyWith(
      questionText: event.questionText,
      choices: event.choices,
      correctIndex: event.correctIndex,
    );

    _persist(updated);
    emit(state.copyWith(questions: updated, resetView: true));
  }

  void _onDelete(DeleteQuestion event, Emitter<AdminQuestionsState> emit) {
    if (event.index < 0 || event.index >= state.questions.length) return;

    final updated = List<QuestionItem>.from(state.questions)
      ..removeAt(event.index);

    _persist(updated);
    emit(state.copyWith(questions: updated, resetView: true));
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

    emit(state.copyWith(questions: updated));
  }

  static void persistForLesson(
    String lessonTitle,
    List<QuestionItem> questions,
  ) {
    _store[lessonTitle] = List.from(questions);
  }
}
