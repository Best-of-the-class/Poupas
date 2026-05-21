import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_interceptor.dart';

class AuthSession {
  final String token;
  final String tipo;

  const AuthSession({required this.token, required this.tipo});
}

class AuthService {
  final ApiInterceptor _interceptor = ApiInterceptor();

  AuthService();

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
      debugPrint('Erro no interceptor (Cadastro): $e');
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
      debugPrint('Erro no interceptor (Login): $e');
      return false;
    }
  }

  Future<AuthSession?> loginAndStoreSession(
    String email,
    String senha, {
    bool isAdmin = false,
  }) async {
    try {
      final response = await _interceptor.post(
        isAdmin ? '/Autenticacao/login-admin' : '/Autenticacao/login',
        {'email': email, 'senha': senha},
      );

      if (response.statusCode != 200) {
        return null;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final token = (body['token'] ?? body['Token'] ?? '').toString();
      final tipo = (body['tipo'] ?? body['Tipo'] ?? 'estudante').toString();

      if (token.isEmpty) {
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('tipo', tipo);

      return AuthSession(token: token, tipo: tipo);
    } catch (e) {
      debugPrint('Erro ao persistir sessão: $e');
      return null;
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
      debugPrint('Erro solicitarResetSenha: $e');
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
      debugPrint('Erro verificarCodigo: $e');
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
      debugPrint('Erro redefinirSenha: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _interceptor.post('/Usuario/logout', {});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro logout: $e');
      return false;
    }
  }

  Future<void> deletarConta(String email, String senha) async {
    try {
      final response = await _interceptor.delete('/Usuario/deletar', {
        'email': email,
        'senha': senha,
      });

      if (response.statusCode == 200) {
        return;
      }

      throw Exception(
        _extractMessage(
          response.body,
          fallback: 'Não foi possível excluir a conta.',
        ),
      );
    } catch (e) {
      debugPrint('Erro deletarConta: $e');
      rethrow;
    }
  }

  String _extractMessage(String body, {required String fallback}) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['mensagem'] ?? decoded['Mensagem'];
        if (message != null) {
          return message.toString();
        }
      }
    } catch (_) {
      return fallback;
    }

    return fallback;
  }
}
