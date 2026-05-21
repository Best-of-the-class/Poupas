import 'package:flutter_test/flutter_test.dart';
import 'package:pomo/core/features/lesson/presentation/entities/lesson_completion_result.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_question_page.dart';
import 'package:pomo/core/features/user_profile/presentation/entities/user_profile_data.dart';

void main() {
  group('UserProfileData.fromJson', () {
    test('mapeia o payload do backend para o perfil do usuário', () {
      final profile = UserProfileData.fromJson({
        'nomeUsuario': 'Ana Poupas',
        'email': 'ana@email.com',
        'avatarId': 3,
        'licoesConcluidas': 7,
        'exerciciosResolvidos': 19,
        'pontuacao': 420,
        'sequenciaDias': 5,
        'quantVidas': 4,
        'conquistas': [
          {
            'id': 1,
            'titulo': 'Primeiros passos',
            'descricao': 'Concluiu a primeira lição',
            'icone': 'pencil',
            'tipoDesbloqueio': 'licao',
            'backgroundCor': 'green',
            'desbloqueada': true,
            'conquistadoEm': '2026-05-20T12:00:00Z',
          },
        ],
      });

      expect(profile.name, 'Ana Poupas');
      expect(profile.email, 'ana@email.com');
      expect(profile.avatarId, 3);
      expect(profile.completedLessons, 7);
      expect(profile.solvedExercises, 19);
      expect(profile.xp, 420);
      expect(profile.streakDays, 5);
      expect(profile.lives, 4);
      expect(profile.achievements, hasLength(1));
      expect(profile.achievements.first.title, 'Primeiros passos');
      expect(profile.achievements.first.isUnlocked, isTrue);
      expect(avatarAssetForId(profile.avatarId), contains('avatar_3.png'));
    });
  });

  group('LessonCompletionResult.fromJson', () {
    test('mapeia o retorno de conclusão de lição com XP por atividade', () {
      final result = LessonCompletionResult.fromJson({
        'acertos': 3,
        'erros': 1,
        'xp': 38,
        'xpTotalUsuario': 458,
        'ganhouSequencia': true,
        'vidasRestantes': 4,
        'sequenciaAtual': 6,
        'xpPorAtividade': [
          {
            'atividadeId': 10,
            'correta': true,
            'xpGanho': 12,
            'jaPontuadaAnteriormente': false,
          },
          {
            'atividadeId': 11,
            'correta': false,
            'xpGanho': 0,
            'jaPontuadaAnteriormente': false,
          },
        ],
        'novasConquistas': [
          {
            'id': 2,
            'titulo': 'Poup Aprendiz',
            'descricao': '10 respostas corretas',
            'icone': 'student',
            'tipoDesbloqueio': 'respostas',
            'backgroundCor': 'blue',
            'desbloqueada': true,
          },
        ],
      });

      expect(result.correctAnswers, 3);
      expect(result.wrongAnswers, 1);
      expect(result.earnedXp, 38);
      expect(result.totalXp, 458);
      expect(result.gainedStreak, isTrue);
      expect(result.remainingLives, 4);
      expect(result.currentStreak, 6);
      expect(result.xpByActivity, hasLength(2));
      expect(result.xpByActivity.first.activityId, 10);
      expect(result.xpByActivity.first.earnedXp, 12);
      expect(result.newAchievements, hasLength(1));
      expect(result.newAchievements.first.iconName, 'student');
    });
  });

  group('optionLabelForIndex', () {
    test('gera rotulos para quantidades variaveis de alternativas', () {
      expect(optionLabelForIndex(0), 'A');
      expect(optionLabelForIndex(3), 'D');
      expect(optionLabelForIndex(26), '27');
    });
  });
}
