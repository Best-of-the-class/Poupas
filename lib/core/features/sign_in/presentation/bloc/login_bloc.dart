import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_validator.dart';

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

  final List<Map<String, String>> fakeUsers = [
    {'email': 'teste@email.com', 'password': '123456'},
    {'email': 'ana@email.com', 'password': 'abc123'},
  ];

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

    await Future.delayed(const Duration(seconds: 1));

    final user = fakeUsers.firstWhere(
      (u) =>
          u['email'] == event.email &&
          u['password'] == event.password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      emit(LoginError('Email ou senha incorretos'));
    } else {
      emit(LoginSuccess());
    }
  }
}