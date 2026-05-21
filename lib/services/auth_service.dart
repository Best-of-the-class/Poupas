import '../core/network/api_interceptor.dart';
import '../core/network/adapters/go_adapter.dart';

class AuthService {
  final ApiInterceptor _interceptor = ApiInterceptor();
  final GoSecurityAdapter? _go;

  AuthService([this._go]);

  Future<bool> cadastrar(String nome, String email, String senha) async {
    try {
      final response = await _interceptor.post('/Autenticacao/cadastro', {
        "nomeUsuario": nome,
        "email": email,
        "senha": senha,
        "confirmarSenha": senha, 
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

  Future<bool> solicitarResetSenha(String email) async {
    try {
      final response = await _interceptor.post(
        '/Autenticacao/recuperar-senha',
        {"email": email},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Erro solicitarResetSenha: $e");
      return false;
    }
  }

  Future<bool> verificarCodigo(String email, String codigo) async {
    try {
      final response = await _interceptor.post(
        '/Autenticacao/verificar-codigo',
        {"email": email, "codigo": codigo},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Erro verificarCodigo: $e");
      return false;
    }
  }

  Future<bool> redefinirSenha(
    String email,
    String codigo,
    String novaSenha,
  ) async {
    try {
      final response = await _interceptor.post(
        '/Autenticacao/redefinir-senha',
        {"email": email, "codigo": codigo, "novaSenha": novaSenha},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Erro redefinirSenha: $e");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _interceptor.post('/Usuario/logout', {});
      return response.statusCode == 200;
    } catch (e) {
      print("Erro logout: $e");
      return false;
    }
  }

  Future<bool> deletarConta(String email, String senha) async {
    try {
      final response = await _interceptor.delete('/Usuario/deletar', {
        "email": email,
        "senha": senha,
      });
      return response.statusCode == 200;
    } catch (e) {
      print("Erro deletarConta: $e");
      return false;
    }
  }
}