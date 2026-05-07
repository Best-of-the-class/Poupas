import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/features/edit_profile/presentation/pages/edit_profile_page.dart';
import '../../features/sign_in/presentation/pages/loading_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/user_profile/presentation/pages/profile_page.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';
import '../../features/sign_in/presentation/pages/sign_in_password_page.dart';
import '../../features/sign_in/presentation/pages/sign_in_page.dart';
import '../../features/login/presentation/pages/login_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_code_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_reset_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_confirmation.dart';
import '../../features/entry/presentation/pages/welcome_page.dart';
import '../../features/lesson/presentation/pages/lesson_page.dart';
import '../../features/badges/presentation/pages/badges_page.dart';
import '../../features/practice/presentation/pages/practice_intro_page.dart';
import '../../features/practice/presentation/pages/practice_page.dart';
import '../../features/entry/presentation/pages/LoadingInitialPage.dart';
import '../../features/admin/presentation/pages/admin_activities_page.dart';
import '../../features/admin/presentation/pages/admin_theory_page.dart';
import '../../features/admin/presentation/pages/admin_questions_page.dart';
import '../../features/admin/presentation/pages/admin_edit_questions_page.dart';
import '../../features/admin/presentation/pages/admin_success_page.dart';
import '../../features/admin/presentation/pages/admin_dictionary_page.dart';
import '../../widgets/module.dart';

class RoutesAdapter {
  static String initialLocation = '/loadingWelcome';
  static const String loadingWelcome = 'loadingWelcome';
  static const String welcome = 'welcome';
  static const String signIn = 'sign-in';
  static const String signInPassword = 'sign-in-password';
  static const String login = 'login';
  static const String home = 'home';
  static const String load = 'load';
  static const String forgotPassword = 'forgot_password';
  static const String resetPasswordVerification = 'reset_password_verification';
  static const String resetPasswordNewPassword = 'reset_password_new_password';
  static const String resetPasswordConfirmation = 'reset_password_confirmation';
  static const String profile = 'profile';
  static const String lesson = 'lesson';
  static const String badges = 'badges';
  static const String practiceIntro = 'practice-intro';
  static const String practice = 'practice';
  static const String adminActivities = 'adminActivities';
  static const String adminTheory = 'adminTheory';
  static const String adminQuestions = 'adminQuestions';
  static const String editProfile = 'edit-profile';
  static const String adminEditQuestions = 'adminEditQuestions';
  static const String adminSuccess = 'adminSuccess';
  static const String adminDictionary = 'adminDictionary';
  static bool get isDesktopAdmin {
    final result = !kIsWeb && (Platform.isWindows || Platform.isLinux);
    return result;
  }

  static GoRouter? _router;

  static GoRouter get router {
    _router ??= GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          name: loadingWelcome,
          path: '/loadingWelcome',
          builder: (context, state) => const LoadingWelcomePage(),
        ),
        GoRoute(
          name: welcome,
          path: '/welcome',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          name: signIn,
          path: '/signIn',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          name: login,
          path: '/login',
          builder: (context, state) => BlocProvider(
            create: (_) => LoginBloc(),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          name: signInPassword,
          path: '/signInPassword',
          builder: (context, state) =>
              SignInPagePassword(email: state.extra as String),
        ),
        GoRoute(
          name: forgotPassword,
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          name: resetPasswordVerification,
          path: '/forgot-password/verify',
          builder: (context, state) => const ForgotPasswordCodePage(),
        ),
        GoRoute(
          name: resetPasswordNewPassword,
          path: '/forgot-password/new-password',
          builder: (context, state) => const ForgotPasswordResetPage(),
        ),
        GoRoute(
          name: resetPasswordConfirmation,
          path: '/forgot-password/success',
          builder: (context, state) => const ForgotPasswordConfirmation(),
        ),
        GoRoute(
          name: home,
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          name: lesson,
          path: '/lesson',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;

            return LessonPage(
              licao: data['licao'],
              atividades: data['atividades'],
            );
          },
        ),
        GoRoute(
          name: badges,
          path: '/badges',
          builder: (context, state) => const BadgesPage(),
        ),
        GoRoute(
          name: practiceIntro,
          path: '/practice-intro',
          builder: (context, state) => const PracticeIntroPage(),
        ),
        GoRoute(
          name: practice,
          path: '/practice',
          builder: (context, state) => const PracticePage(),
        ),
        GoRoute(
          name: load,
          path: '/loading',
          builder: (context, state) => const LoadingPage(),
        ),
        GoRoute(
          name: profile,
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          name: adminActivities,
          path: '/admin-activities',
          redirect: (context, state) =>
              !isDesktopAdmin ? '/loadingWelcome' : null,
          builder: (context, state) => const AdminActivities(),
        ),
        GoRoute(
          name: adminTheory,
          path: '/admin-theory',
          builder: (context, state) {
            if (state.extra is String) {
              return AdminTheory(
                difficulty: ModuleDifficulty.easy,
                editLessonTitle: state.extra as String,
              );
            }
            final difficulty = state.extra as ModuleDifficulty;
            return AdminTheory(difficulty: difficulty);
          },
        ),
        GoRoute(
          name: adminQuestions,
          path: '/admin-questions',
          builder: (context, state) {
            final difficulty = state.extra as ModuleDifficulty;
            return AdminQuestions(difficulty: difficulty);
          },
        ),
        GoRoute(
          name: adminEditQuestions,
          path: '/admin-edit-questions',
          builder: (context, state) {
            final aulaNome = state.extra as String?;
            return AdminEditQuestions(lessonTitle: aulaNome);
          },
        ),
        GoRoute(
          name: adminSuccess,
          path: '/admin-success',
          builder: (context, state) => const AdminSuccessPage(),
        ),
        GoRoute(
          name: adminDictionary,
          path: '/admin-dictionary',
          builder: (context, state) => const AdminDictionary(),
        ),
        GoRoute(
          name: editProfile,
          path: '/edit-profile',
          builder: (context, state) => const EditProfilePage(),
        ),
      ],
    );
    return _router!;
  }
}
