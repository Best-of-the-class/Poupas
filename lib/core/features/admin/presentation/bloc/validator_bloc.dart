import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LessonTitleValidatorEvent {}

class ValidateLesson extends LessonTitleValidatorEvent {
  final String title;
  final String content;
  ValidateLesson(this.title, this.content);
}

class ResetTitleValidation extends LessonTitleValidatorEvent {}

abstract class LessonTitleValidatorState {}

class TitleInitial extends LessonTitleValidatorState {}

class TitleSuccess extends LessonTitleValidatorState {
  final String title;
  TitleSuccess(this.title);
}

class TitleFailureEffect extends LessonTitleValidatorState {
  final String message;
  final int id;
  TitleFailureEffect(this.message) : id = DateTime.now().microsecondsSinceEpoch;
}

class LessonTitleValidatorBloc
    extends Bloc<LessonTitleValidatorEvent, LessonTitleValidatorState> {
  LessonTitleValidatorBloc() : super(TitleInitial()) {
    on<ResetTitleValidation>((event, emit) => emit(TitleInitial()));

    on<ValidateLesson>((event, emit) {
      final title = event.title.trim();
      final content = event.content.trim();

      if (title.isEmpty) {
        emit(TitleFailureEffect('O título da teoria não pode estar vazio!'));
      } else if (title.length > 150) {
        emit(TitleFailureEffect('O título deve ter no máximo 150 caracteres.'));
      } else if (content.isEmpty) {
        emit(TitleFailureEffect('O conteúdo da teoria não pode estar vazio!'));
      } else {
        emit(TitleSuccess(title));
      }
    });
  }
}
