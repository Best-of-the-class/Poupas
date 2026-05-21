import 'dart:convert';

import 'package:pomo/core/features/user_profile/presentation/entities/user_profile_data.dart';

import '../core/network/api_interceptor.dart';

class ProfileServiceException implements Exception {
  final String message;

  const ProfileServiceException(this.message);

  @override
  String toString() => message;
}

class ProfileService {
  final ApiInterceptor _api = ApiInterceptor();

  Future<UserProfileData> fetchProfile() async {
    final response = await _api.get('/Perfil');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return UserProfileData.fromJson(body);
    }

    throw ProfileServiceException(
      _extractMessage(
        response.body,
        fallback: 'Não foi possível carregar o perfil.',
      ),
    );
  }

  Future<UserProfileData> updateProfile({
    required String currentEmail,
    required String newName,
    required String newEmail,
    required int avatarId,
  }) async {
    final response = await _api.put('/Perfil/editar', {
      'email': currentEmail,
      'novoNome': newName,
      'novoEmail': newEmail,
      'avatarId': avatarId,
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return UserProfileData.fromJson(body);
    }

    throw ProfileServiceException(
      _extractMessage(
        response.body,
        fallback: 'Não foi possível salvar as alterações do perfil.',
      ),
    );
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
