import 'package:pomo/core/features/sign_in/presentation/entities/user_registration.dart';

class ResetPasswordData extends RegistrationData {
  final String code;

  ResetPasswordData({super.email = '', super.password = '', this.code = ''})
    : super(name: '');

  ResetPasswordData copyWith({String? email, String? code, String? password}) {
    return ResetPasswordData(
      email: email ?? this.email,
      password: password ?? this.password,
      code: code ?? this.code,
    );
  }
}
