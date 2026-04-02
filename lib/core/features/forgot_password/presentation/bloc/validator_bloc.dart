import '../../../sign_in/presentation/bloc/validator_bloc.dart';
import '../../domain/entities/user_reset_password.dart';
import '../../../../../services/auth_service.dart';

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

    on<ValidateEmailStep>((event, emit) async {
      if (event.email.trim().isEmpty) {
        emit(ValidationFailure('Preencha com o email'));
      } else if (!event.email.contains('@')) {
        emit(ValidationFailure('E-mail inválido'));
      } else {
        final authService = AuthService();
        final ok = await authService.solicitarResetSenha(event.email);
        if (ok) {
          _tempEmail = event.email;
          emit(ValidationSuccess(ResetPasswordData(email: _tempEmail)));
        } else {
          emit(ValidationFailure('Não foi possível enviar o código. Verifique o e-mail e tente novamente.'));
        }
      }
    });

    on<ValidateCodeStep>((event, emit) async {
      if (event.code.trim().length < 4) {
        emit(ValidationFailure('Código inválido'));
      } else {
        final authService = AuthService();
        final ok = await authService.verificarCodigo(_tempEmail, event.code);
        if (ok) {
          _tempCode = event.code;
          emit(
            ValidationSuccess(
              ResetPasswordData(email: _tempEmail, code: _tempCode),
            ),
          );
        } else {
          emit(ValidationFailure('Código incorreto ou expirado. Solicite um novo.'));
        }
      }
    });

    on<ValidatePasswordStep>((event, emit) async {
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
        final authService = AuthService();
        final ok = await authService.redefinirSenha(
          _tempEmail,
          _tempCode,
          event.password,
        );
        if (ok) {
          emit(
            ValidationSuccess(
              ResetPasswordData(
                email: _tempEmail,
                code: _tempCode,
                password: event.password,
              ),
            ),
          );
        } else {
          emit(ValidationFailure('Não foi possível redefinir a senha. Tente novamente.'));
        }
      }
    });
  }
}