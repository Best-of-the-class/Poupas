import '../../../sign_in/presentation/bloc/validator_bloc.dart';
import '../entities/user_reset_password.dart';
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

  ValidatePasswordStep({
    required this.password,
    required this.confirmPassword,
  });
}

class PasswordResetValidatorBloc extends ValidatorBloc {
  final AuthService authService;

  String _tempEmail = '';
  String _tempCode = '';

  PasswordResetValidatorBloc(this.authService) : super() {
    on<ResetValidation>((event, emit) {
      emit(ValidatorInitial());
    });

    on<ValidateEmailStep>((event, emit) async {
      if (event.email.trim().isEmpty) {
        emit(ValidationFailure('Preencha com o email'));
        return;
      }

      if (!event.email.contains('@')) {
        emit(ValidationFailure('E-mail inválido'));
        return;
      }

      final ok = await authService.solicitarResetSenha(event.email);

      if (ok) {
        _tempEmail = event.email;
        emit(ValidationSuccess(ResetPasswordData(email: _tempEmail)));
      } else {
        emit(ValidationFailure(
          'Não foi possível enviar o código. Tente novamente.',
        ));
      }
    });

    on<ValidateCodeStep>((event, emit) async {
      if (event.code.trim().length < 4) {
        emit(ValidationFailure('Código inválido'));
        return;
      }

      final ok = await authService.verificarCodigo(_tempEmail, event.code);

      if (ok) {
        _tempCode = event.code;
        emit(ValidationSuccess(
          ResetPasswordData(email: _tempEmail, code: _tempCode),
        ));
      } else {
        emit(ValidationFailure('Código incorreto ou expirado.'));
      }
    });

    on<ValidatePasswordStep>((event, emit) async {
      final regex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{6,}$',
      );

      if (event.password.isEmpty) {
        emit(ValidationFailure('Preencha a senha'));
        return;
      }

      if (!regex.hasMatch(event.password)) {
        emit(ValidationFailure('Senha fraca'));
        return;
      }

      if (event.password != event.confirmPassword) {
        emit(ValidationFailure('Senhas não coincidem'));
        return;
      }

      final ok = await authService.redefinirSenha(
        _tempEmail,
        _tempCode,
        event.password,
      );

      if (ok) {
        emit(ValidationSuccess(
          ResetPasswordData(
            email: _tempEmail,
            code: _tempCode,
            password: event.password,
          ),
        ));
      } else {
        emit(ValidationFailure('Erro ao redefinir senha'));
      }
    });
  }
}