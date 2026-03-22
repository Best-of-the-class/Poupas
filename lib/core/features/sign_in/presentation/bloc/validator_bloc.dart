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
  ValidateStepTwo({required this.password});
}

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
      if (event.name.trim().length < 3) {
        emit(
          ValidationFailure('Nome muito curto, deve ter no mínimo 3 letras'),
        );
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
      if (event.password.length < 8) {
        emit(
          ValidationFailure(
            'A senha muito curta, deve ter no mínimo 8 caracteres',
          ),
        );
      } else {
        final finalData = RegistrationData(
          name: _tempName,
          email: _tempEmail,
          password: event.password,
        );
        emit(ValidationSuccess(finalData));
      }
    });
  }
}
