import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ValidatorEvent {}
class ValidateStep extends ValidatorEvent {
  final String data;
  final String type; 
  ValidateStep(this.data, this.type);
}

abstract class ValidatorState {}
class ValidatorInitial extends ValidatorState {}
class ValidationSuccess extends ValidatorState {
  final String data;
  ValidationSuccess(this.data);
}
class ValidationFailure extends ValidatorState {
  final String message;
  ValidationFailure(this.message);
}

class ValidatorBloc extends Bloc<ValidatorEvent, ValidatorState> {
  ValidatorBloc() : super(ValidatorInitial()) {
    on<ValidateStep>((event, emit) {
      if (event.type == 'email') {
        if (event.data.contains('@') && event.data.length > 5) {
          emit(ValidationSuccess(event.data));
        } else {
          emit(ValidationFailure('Email inválido'));
        }
      } else if (event.type == 'password') {
        if (event.data.length >= 8) {
          emit(ValidationSuccess(event.data));
        } else {
          emit(ValidationFailure('Senha deve conter no mínimo 8 caracteres'));
        }
      }
    });
  }
}