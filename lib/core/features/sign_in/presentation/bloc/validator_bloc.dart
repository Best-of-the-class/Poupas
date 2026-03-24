import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_registration.dart';

abstract class ValidatorEvent {}

class ValidateStepOne extends ValidatorEvent {
  final String name;
  final String email;
  ValidateStepOne({required this.name, required this.email});
}

class ValidateStepTwo extends ValidatorEvent {
  final String password;
  final String confirmPassword;
  ValidateStepTwo({required this.password, required this.confirmPassword});
}

class ClearValidationError extends ValidatorEvent {}

abstract class ValidatorState {}

class ValidatorInitial extends ValidatorState {}

class ValidationSuccess extends ValidatorState {
  final RegistrationData data;
  ValidationSuccess(this.data);
}

class ValidationFailure extends ValidatorState {
  final String message;
  ValidationFailure(this.message);
}

class ValidatorBloc extends Bloc<ValidatorEvent, ValidatorState> {
  String _tempName = '';
  String _tempEmail = '';

  ValidatorBloc() : super(ValidatorInitial()) {
    on<ValidateStepOne>((event, emit) {
      if (event.name.trim().isEmpty && event.name.trim().isEmpty) {
        emit(ValidationFailure('Preencha todos os campos'));
      } else if (event.name.trim().isEmpty) {
        emit(ValidationFailure('Preencha com o nome'));
      } else if (event.name.trim().length < 6) {
        emit(
          ValidationFailure('Nome muito curto, deve ter no mínimo 6 letras'),
        );
      } else if (event.email.trim().isEmpty) {
        emit(ValidationFailure('Preencha com o email'));
      } else if (!event.email.contains('@')) {
        emit(ValidationFailure('E-mail inválido'));
      } else {
        _tempName = event.name;
        _tempEmail = event.email;
        emit(
          ValidationSuccess(
            RegistrationData(name: _tempName, email: _tempEmail),
          ),
        );
      }
    });

    on<ValidateStepTwo>((event, emit) {
      final regex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$',
      );
      if (event.password.trim().isEmpty) {
        emit(ValidationFailure('Preencha com a senha'));
      } else if (event.password.length < 6) {
        emit(
          ValidationFailure(
            'A senha muito curta, deve ter no mínimo 6 caracteres',
          ),
        );
      } else if (!regex.hasMatch(event.password)) {
        emit(
          ValidationFailure(
            'A senha deve conter letras, números e caracteres especiais',
          ),
        );
      } else if (event.password != event.confirmPassword) {
        emit(ValidationFailure('As senhas não coincidem'));
      } else {
        final finalData = RegistrationData(
          name: _tempName,
          email: _tempEmail,
          password: event.password,
        );
        emit(ValidationSuccess(finalData));
      }
    });

    on<ClearValidationError>((event, emit) {
      emit(ValidatorInitial());
    });
  }
}
