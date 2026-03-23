class RegistrationData {
  final String name;
  final String email;
  final String password;

  RegistrationData({
    required this.name,
    required this.email,
    this.password = '',
  });
}
