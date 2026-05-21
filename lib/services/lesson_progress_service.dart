import 'dart:convert';

import 'package:pomo/core/features/lesson/presentation/entities/lesson_completion_result.dart';

import '../core/network/api_interceptor.dart';

class LessonProgressServiceException implements Exception {
  final String message;

  const LessonProgressServiceException(this.message);

  @override
  String toString() => message;
}

class LessonProgressService {
  final ApiInterceptor _api = ApiInterceptor();

  Future<LessonCompletionResult> completeLesson({
    required int lessonId,
    required List<Map<String, dynamic>> responses,
  }) async {
    final response = await _api.post('/Licao/concluir', {
      'licaoId': lessonId,
      'respostas': responses,
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return LessonCompletionResult.fromJson(body);
    }

    throw LessonProgressServiceException(
      _extractMessage(
        response.body,
        fallback: 'Não foi possível concluir a lição.',
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
