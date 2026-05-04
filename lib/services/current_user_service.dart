import 'package:shared_preferences/shared_preferences.dart';

class CurrentUserService {
  CurrentUserService._();

  static final CurrentUserService instance = CurrentUserService._();
  static const String _nameKey = 'current_user_name';
  static const String _emailKey = 'current_user_email';

  String? _name;
  String? _email;

  String? get name => _name;
  String? get email => _email;
  bool get isLoggedIn => (_email ?? '').isNotEmpty;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString(_emailKey);
    _name = prefs.getString(_nameKey);
  }

  Future<void> setUser({required String email, String? name}) async {
    _email = email.trim();
    if (name != null && name.trim().isNotEmpty) {
      _name = name.trim();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, _email!);

    if ((_name ?? '').isNotEmpty) {
      await prefs.setString(_nameKey, _name!);
    }
  }

  Future<void> clear() async {
    _name = null;
    _email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_nameKey);
  }
}
