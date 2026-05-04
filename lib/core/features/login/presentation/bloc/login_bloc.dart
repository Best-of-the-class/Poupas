import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../services/current_user_service.dart';
import 'login_validator.dart';
import '../../../../network/api_interceptor.dart'; 

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted(this.email, this.password);
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLogin);
  }

  // Instanciando o nosso "Caminhão Blindado"
  final ApiInterceptor _api = ApiInterceptor(); 
  final CurrentUserService _currentUser = CurrentUserService.instance;

  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {

    final validationError =
        LoginValidator.validate(event.email, event.password);

    if (validationError != null) {
      emit(LoginError(validationError));
      return;
    }

    emit(LoginLoading());

    try {
      final response = await _api.post(
        '/Autenticacao/login', 
        {
          'email': event.email,
          'senha': event.password,
        }
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        await _currentUser.setUser(
          email: event.email,
          name: body['nome'] ?? body['Nome'],
        );
        emit(LoginSuccess());
      } else if (response.statusCode == 401) {
        final body = jsonDecode(response.body);
        emit(LoginError(body['mensagem'] ?? 'Email ou senha incorretos'));
      } else {
        print('Erro do servidor: ${response.statusCode} - ${response.body}');
        emit(LoginError('Erro no servidor. Tente novamente mais tarde.'));
      }
    } catch (e) {
      emit(LoginError('Não foi possível conectar ao servidor. Verifique sua conexão.'));
      print('Erro no login: $e');
    }
  }
}
