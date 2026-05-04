class UserProfile {
  final String nomeUsuario;
  final String email;
  final int licoesConcluidas;
  final int exerciciosResolvidos;
  final int pontuacao;
  final int sequenciaDias;

  const UserProfile({
    required this.nomeUsuario,
    required this.email,
    required this.licoesConcluidas,
    required this.exerciciosResolvidos,
    required this.pontuacao,
    required this.sequenciaDias,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nomeUsuario: (json['nomeUsuario'] ?? json['NomeUsuario'] ?? '')
          .toString(),
      email: (json['email'] ?? json['Email'] ?? '').toString(),
      licoesConcluidas: _toInt(
        json['licoesConcluidas'] ?? json['LicoesConcluidas'],
      ),
      exerciciosResolvidos: _toInt(
        json['exerciciosResolvidos'] ?? json['ExerciciosResolvidos'],
      ),
      pontuacao: _toInt(json['pontuacao'] ?? json['Pontuacao']),
      sequenciaDias: _toInt(json['sequenciaDias'] ?? json['SequenciaDias']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
