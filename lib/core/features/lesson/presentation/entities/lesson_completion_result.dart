import 'package:pomo/core/features/user_profile/presentation/entities/user_profile_data.dart';

class LessonXpActivityResult {
  final int activityId;
  final bool isCorrect;
  final int earnedXp;
  final bool alreadyScored;

  const LessonXpActivityResult({
    required this.activityId,
    required this.isCorrect,
    required this.earnedXp,
    required this.alreadyScored,
  });

  factory LessonXpActivityResult.fromJson(Map<String, dynamic> json) {
    return LessonXpActivityResult(
      activityId: _readInt(json, const ['atividadeId', 'AtividadeId']),
      isCorrect: _readBool(json, const ['correta', 'Correta']),
      earnedXp: _readInt(json, const ['xpGanho', 'XpGanho']),
      alreadyScored: _readBool(json, const [
        'jaPontuadaAnteriormente',
        'JaPontuadaAnteriormente',
      ]),
    );
  }
}

class LessonCompletionResult {
  final int correctAnswers;
  final int wrongAnswers;
  final int earnedXp;
  final int totalXp;
  final bool gainedStreak;
  final int remainingLives;
  final int currentStreak;
  final List<LessonXpActivityResult> xpByActivity;
  final List<UserAchievement> newAchievements;

  const LessonCompletionResult({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.earnedXp,
    required this.totalXp,
    required this.gainedStreak,
    required this.remainingLives,
    required this.currentStreak,
    required this.xpByActivity,
    required this.newAchievements,
  });

  factory LessonCompletionResult.fromJson(Map<String, dynamic> json) {
    final xpRaw = _readList(json, const ['xpPorAtividade', 'XpPorAtividade']);
    final achievementsRaw = _readList(json, const [
      'novasConquistas',
      'NovasConquistas',
    ]);

    return LessonCompletionResult(
      correctAnswers: _readInt(json, const ['acertos', 'Acertos']),
      wrongAnswers: _readInt(json, const ['erros', 'Erros']),
      earnedXp: _readInt(json, const ['xp', 'Xp']),
      totalXp: _readInt(json, const ['xpTotalUsuario', 'XpTotalUsuario']),
      gainedStreak: _readBool(json, const [
        'ganhouSequencia',
        'GanhouSequencia',
      ]),
      remainingLives: _readInt(json, const [
        'vidasRestantes',
        'VidasRestantes',
      ], fallback: 5),
      currentStreak: _readInt(json, const ['sequenciaAtual', 'SequenciaAtual']),
      xpByActivity: xpRaw
          .whereType<Map<String, dynamic>>()
          .map(LessonXpActivityResult.fromJson)
          .toList(growable: false),
      newAchievements: achievementsRaw
          .whereType<Map<String, dynamic>>()
          .map(UserAchievement.fromJson)
          .toList(growable: false),
    );
  }
}

int _readInt(Map<String, dynamic> json, List<String> keys, {int fallback = 0}) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value != null) {
      return int.tryParse(value.toString()) ?? fallback;
    }
  }

  return fallback;
}

bool _readBool(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    if (value != null) {
      return value.toString().toLowerCase() == 'true';
    }
  }

  return false;
}

List<dynamic> _readList(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is List<dynamic>) {
      return value;
    }
  }

  return const [];
}
