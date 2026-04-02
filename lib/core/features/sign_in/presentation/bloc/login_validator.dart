class LoginValidator {
  static String? validate(String email, String password) {
    if (email.trim().isEmpty && password.trim().isEmpty) {
      return 'Preencha email e senha';
    }

    if (email.trim().isEmpty) {
      return 'Preencha o email';
    }

    if (!email.contains('@')) {
      return 'Email inválido';
    }

    if (password.trim().isEmpty) {
      return 'Preencha a senha';
    }

    return null;
  }
}