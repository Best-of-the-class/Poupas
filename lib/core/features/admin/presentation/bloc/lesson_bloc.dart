import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/module.dart';

abstract class LessonEvent {}

class CreateLesson extends LessonEvent {
  final String title;
  final ModuleDifficulty difficulty;
  CreateLesson(this.title, this.difficulty);
}

class DeleteLesson extends LessonEvent {
  final ModuleDifficulty difficulty;
  final int index;
  DeleteLesson(this.difficulty, this.index);
}

class LessonState {
  final Map<ModuleDifficulty, List<String>> lessonsByDifficulty;

  const LessonState({required this.lessonsByDifficulty});

  factory LessonState.initial() {
    return const LessonState(
      lessonsByDifficulty: {
        ModuleDifficulty.easy: ['Juros Composto'],
        ModuleDifficulty.medium: ['Capital de Giro'],
        ModuleDifficulty.hard: ['Equivalência de Capitais'],
      },
    );
  }

  LessonState copyWith({
    Map<ModuleDifficulty, List<String>>? lessonsByDifficulty,
  }) {
    return LessonState(
      lessonsByDifficulty: lessonsByDifficulty ?? this.lessonsByDifficulty,
    );
  }
}

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc() : super(LessonState.initial()) {
    on<CreateLesson>(_onCreate);
    on<DeleteLesson>(_onDelete);
  }

  void _onCreate(CreateLesson event, Emitter<LessonState> emit) {
    final updated = Map<ModuleDifficulty, List<String>>.from(
      state.lessonsByDifficulty,
    );
    updated[event.difficulty] = List<String>.from(
      updated[event.difficulty] ?? [],
    )..add(event.title);
    emit(state.copyWith(lessonsByDifficulty: updated));
  }

  void _onDelete(DeleteLesson event, Emitter<LessonState> emit) {
    final updated = Map<ModuleDifficulty, List<String>>.from(
      state.lessonsByDifficulty,
    );
    final list = List<String>.from(updated[event.difficulty] ?? []);
    if (event.index >= 0 && event.index < list.length) {
      list.removeAt(event.index);
      updated[event.difficulty] = list;
      emit(state.copyWith(lessonsByDifficulty: updated));
    }
  }
}
