import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/validator_bloc.dart';

abstract class AdminNavigationEvent {}

class AdminNavigateToNext extends AdminNavigationEvent {
  final String routeName;
  AdminNavigateToNext(this.routeName);
}

class AdminShowError extends AdminNavigationEvent {
  final String message;
  AdminShowError(this.message);
}

abstract class AdminNavigationState {}

class AdminNavInitial extends AdminNavigationState {}

class AdminNavSideEffect extends AdminNavigationState {
  final String routeName;
  final int id;
  AdminNavSideEffect(this.routeName)
    : id = DateTime.now().microsecondsSinceEpoch;
}

class AdminErrorEffect extends AdminNavigationState {
  final String message;
  final int id;
  AdminErrorEffect(this.message) : id = DateTime.now().microsecondsSinceEpoch;
}

class AdminNavigationBloc
    extends Bloc<AdminNavigationEvent, AdminNavigationState> {
  final LessonTitleValidatorBloc _validatorBloc;
  late final StreamSubscription _subscription;
  bool isDialogOpen = false;

  AdminNavigationBloc({required LessonTitleValidatorBloc validatorBloc})
    : _validatorBloc = validatorBloc,
      super(AdminNavInitial()) {
    on<AdminNavigateToNext>((event, emit) {
      emit(AdminNavSideEffect(event.routeName));
    });

    on<AdminShowError>((event, emit) {
      emit(AdminErrorEffect(event.message));
    });

    _subscription = _validatorBloc.stream.listen((state) {
      if (state is TitleSuccess) {
        add(AdminNavigateToNext('adminQuestions'));
      } else if (state is TitleFailureEffect) {
        add(AdminShowError(state.message));
      }
    });
  }

  void validateAndCreate(String title, String content) {
    _validatorBloc.add(ResetTitleValidation());
    _validatorBloc.add(ValidateLesson(title, content));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
