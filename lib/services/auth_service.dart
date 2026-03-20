import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ⚠️ ATENÇÃO AO AMBIENTE DE TESTE:
  // Se rodar no Navegador: use 'localhost'
  // Se rodar no Emulador Android: mude para '10.0.2.2'
  final String baseUrl = "https://10.0.2.2:7141/api/Autenticacao";

  Future<bool> cadastrar(String nome, String email, String senha) async {
    final url = Uri.parse('$baseUrl/cadastro');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nomeUsuario": nome,
          "email": email,
          "senha": senha,
          "confirmarSenha": senha
        }),
      );

      if (response.statusCode == 200) {
        print("🎉 Sucesso no backend: ${response.body}");
        return true;
      } else {
        print("❌ Erro no backend: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚨 Erro de conexão: $e");
      return false;
    }
  }

  Future<bool> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "senha": senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Login aprovado! Token: ${data['token']}");
        return true;
      } else {
        print("🚫 Acesso negado: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚨 Erro de conexão: $e");
      return false;
    }
  }
}