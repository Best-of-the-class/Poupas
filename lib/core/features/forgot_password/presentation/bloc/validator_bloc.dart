import '../../../sign_in/presentation/bloc/validator_bloc.dart';
import '../../domain/entities/user_reset_password.dart';

class ResetValidation extends ValidatorEvent {}

class ValidateEmailStep extends ValidatorEvent {
  final String email;
  ValidateEmailStep(this.email);
}

class ValidateCodeStep extends ValidatorEvent {
  final String code;
  ValidateCodeStep(this.code);
}

class ValidatePasswordStep extends ValidatorEvent {
  final String password;
  final String confirmPassword;
  ValidatePasswordStep({required this.password, required this.confirmPassword});
}

class PasswordResetValidatorBloc extends ValidatorBloc {
  String _tempEmail = '';
  String _tempCode = '';

  PasswordResetValidatorBloc() : super() {
    on<ResetValidation>((event, emit) {
      emit(ValidatorInitial());
    });

    on<ValidateEmailStep>((event, emit) {
      if (event.email.trim().isEmpty) {
        emit(ValidationFailure('Preencha com o email'));
      } else if (!event.email.contains('@')) {
        emit(ValidationFailure('E-mail inválido'));
      } else {
        _tempEmail = event.email;
        emit(ValidationSuccess(ResetPasswordData(email: _tempEmail)));
      }
    });

    on<ValidateCodeStep>((event, emit) {
      if (event.code.trim().length < 4) {
        emit(ValidationFailure('Código inválido'));
      } else {
        _tempCode = event.code;
        emit(
          ValidationSuccess(
            ResetPasswordData(email: _tempEmail, code: _tempCode),
          ),
        );
      }
    });

    on<ValidatePasswordStep>((event, emit) {
      final regex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$',
      );

      if (event.password.isEmpty) {
        emit(ValidationFailure('Preencha a senha'));
      } else if (event.password.length < 6) {
        emit(ValidationFailure('Senha muito curta'));
      } else if (!regex.hasMatch(event.password)) {
        emit(
          ValidationFailure('A senha deve conter letras, números e símbolos'),
        );
      } else if (event.password != event.confirmPassword) {
        emit(ValidationFailure('As senhas não coincidem'));
      } else {
        emit(
          ValidationSuccess(
            ResetPasswordData(
              email: _tempEmail,
              code: _tempCode,
              password: event.password,
            ),
          ),
        );
      }
    });
  }
}
