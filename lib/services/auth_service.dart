import '../core/network/api_interceptor.dart';

class AuthService {

  final ApiInterceptor _interceptor = ApiInterceptor();

  Future<bool> cadastrar(String nome, String email, String senha) async {
    try {
      
      final response = await _interceptor.post('/Autenticacao/cadastro', {
        "nomeUsuario": nome,
        "email": email,
        "senha": senha,
        "confirmarSenha": senha
      });
      
      return response.statusCode == 200;
    } catch (e) {
      print("Erro no interceptor (Cadastro): $e");
      return false;
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      final response = await _interceptor.post('/Autenticacao/login', {
        "email": email,
        "senha": senha,
      });
      
      return response.statusCode == 200;
    } catch (e) {
      print("Erro no interceptor (Login): $e");
      return false;
    }
  }
}