import 'dart:convert';

import '../core/features/user_profile/presentation/entities/user_profile.dart';
import '../core/network/api_interceptor.dart';

class ProfileService {
  final ApiInterceptor _interceptor = ApiInterceptor();

  Future<UserProfile> obterPerfil(String email) async {
    final response = await _interceptor.get(
      '/Perfil',
      queryParameters: {'email': email},
    );

    final body = _decodeBody(response.body);

    if (response.statusCode == 200) {
      return UserProfile.fromJson(body);
    }

    throw Exception(
      _extractMessage(body, fallback: 'Erro ao carregar perfil.'),
    );
  }

  Future<UserProfile> editarPerfil({
    required String emailAtual,
    required String novoNome,
    required String novoEmail,
  }) async {
    final response = await _interceptor.put('/Perfil/editar', {
      'email': emailAtual,
      'novoNome': novoNome,
      'novoEmail': novoEmail,
    });

    final body = _decodeBody(response.body);

    if (response.statusCode == 200) {
      return UserProfile.fromJson(body);
    }

    throw Exception(
      _extractMessage(body, fallback: 'Erro ao atualizar perfil.'),
    );
  }

  Map<String, dynamic> _decodeBody(String responseBody) {
    if (responseBody.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{};
  }

  String _extractMessage(
    Map<String, dynamic> body, {
    required String fallback,
  }) {
    return (body['mensagem'] ?? body['Mensagem'] ?? fallback).toString();
  }
}
