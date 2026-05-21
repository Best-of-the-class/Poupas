class UserAchievement {
  final int id;
  final String title;
  final String description;
  final String iconName;
  final String unlockType;
  final String backgroundColorKey;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const UserAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.unlockType,
    required this.backgroundColorKey,
    required this.isUnlocked,
    this.unlockedAt,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      id: _readInt(json, const ['id', 'Id']),
      title: _readString(json, const ['titulo', 'Titulo']),
      description: _readString(json, const ['descricao', 'Descricao']),
      iconName: _readString(json, const ['icone', 'Icone']),
      unlockType: _readString(json, const [
        'tipoDesbloqueio',
        'TipoDesbloqueio',
      ]),
      backgroundColorKey: _readString(json, const [
        'backgroundCor',
        'BackgroundCor',
      ]),
      isUnlocked: _readBool(json, const ['desbloqueada', 'Desbloqueada']),
      unlockedAt: _readDateTime(json, const ['conquistadoEm', 'ConquistadoEm']),
    );
  }
}

class UserProfileData {
  final String name;
  final String email;
  final int avatarId;
  final int completedLessons;
  final int solvedExercises;
  final int xp;
  final int streakDays;
  final int lives;
  final List<UserAchievement> achievements;

  const UserProfileData({
    required this.name,
    required this.email,
    required this.avatarId,
    required this.completedLessons,
    required this.solvedExercises,
    required this.xp,
    required this.streakDays,
    required this.lives,
    required this.achievements,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    final achievementsRaw = _readList(json, const ['conquistas', 'Conquistas']);

    return UserProfileData(
      name: _readString(json, const ['nomeUsuario', 'NomeUsuario']),
      email: _readString(json, const ['email', 'Email']),
      avatarId: _readInt(json, const ['avatarId', 'AvatarId'], fallback: 1),
      completedLessons: _readInt(json, const [
        'licoesConcluidas',
        'LicoesConcluidas',
      ]),
      solvedExercises: _readInt(json, const [
        'exerciciosResolvidos',
        'ExerciciosResolvidos',
      ]),
      xp: _readInt(json, const ['pontuacao', 'Pontuacao']),
      streakDays: _readInt(json, const ['sequenciaDias', 'SequenciaDias']),
      lives: _readInt(json, const ['quantVidas', 'QuantVidas'], fallback: 5),
      achievements: achievementsRaw
          .whereType<Map<String, dynamic>>()
          .map(UserAchievement.fromJson)
          .toList(growable: false),
    );
  }
}

const Map<int, String> _avatarAssetMap = {
  1: 'lib/core/features/user_profile/presentation/assets/images/avatar_1.png',
  2: 'lib/core/features/user_profile/presentation/assets/images/avatar_2.png',
  3: 'lib/core/features/user_profile/presentation/assets/images/avatar_3.png',
  4: 'lib/core/features/user_profile/presentation/assets/images/avatar_4.png',
  5: 'lib/core/features/user_profile/presentation/assets/images/avatar_5.png',
  6: 'lib/core/features/user_profile/presentation/assets/images/avatar_6.png',
};

String avatarAssetForId(int? avatarId) =>
    _avatarAssetMap[avatarId] ?? _avatarAssetMap[1]!;

List<int> get availableAvatarIds =>
    _avatarAssetMap.keys.toList(growable: false);

String _readString(
  Map<String, dynamic> json,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = json[key];
    if (value != null) {
      return value.toString();
    }
  }

  return fallback;
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

DateTime? _readDateTime(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
  }

  return null;
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
