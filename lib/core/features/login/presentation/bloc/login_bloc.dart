import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_validator.dart';
import '../../../../network/api_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final bool isAdmin;

  LoginSubmitted(this.email, this.password, {this.isAdmin = false});
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String tipo;
  LoginSuccess(this.tipo);
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLogin);
  }

  final ApiInterceptor _api = ApiInterceptor();

  Future<void> _onLogin(LoginSubmitted event, Emitter<LoginState> emit) async {
    final validationError = LoginValidator.validate(
      event.email,
      event.password,
    );

    if (validationError != null) {
      emit(LoginError(validationError));
      return;
    }

    emit(LoginLoading());

    try {
      final endpoint = event.isAdmin
          ? '/Autenticacao/login-admin'
          : '/Autenticacao/login';

      final response = await _api.post(endpoint, {
        'email': event.email,
        'senha': event.password,
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final token = (body['token'] ?? body['Token'] ?? '').toString();
        final tipoUsuario =
            (body['tipo'] ?? body['Tipo'] ?? 'estudante').toString();

        if (token.isEmpty) {
          emit(LoginError('Resposta de autenticação inválida.'));
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('tipo', tipoUsuario);

        emit(LoginSuccess(tipoUsuario));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        emit(
          LoginError(
            (body['mensagem'] ?? body['Mensagem'] ?? 'Credenciais inválidas.')
                .toString(),
          ),
        );
      } else {
        emit(LoginError('Erro no servidor. Tente novamente mais tarde.'));
      }
    } catch (e) {
      emit(
        LoginError(
          'Não foi possível conectar ao servidor. Verifique sua conexão.',
        ),
      );
    }
  }
}
