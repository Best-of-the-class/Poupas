import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/features/sign_in/presentation/pages/loading_page.dart';
import '../../features/sign_in/presentation/pages/sign_in_password_page.dart';
import '../../features/sign_in/presentation/pages/sign_in_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_code_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_reset_page.dart';
import '../../features/forgot_password/presentation/pages/forgot_password_confirmation.dart';

class RoutesAdapter {
  static const String signIn = 'sign-in';
  static const String signInPassword = 'sign-in-password';
  static const String loginFake = 'login';
  static const String home = 'home';
  static const String load = 'load';
  static const String forgotPassword = 'forgot_password';
  static const String resetPasswordVerification = 'reset_password_verification';
  static const String resetPasswordNewPassword = 'reset_password_new_password';
  static const String resetPasswordConfirmation = 'reset_password_confirmation';

  static final GoRouter router = GoRouter(
    initialLocation: '/forgot-password',
    routes: [
      GoRoute(
        name: signIn,
        path: '/signIn',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        name: loginFake,
        path: '/login',
        builder: (context, state) => const SignInPage(),
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
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home uepa!!!'))),
      ),
      GoRoute(
        name: load,
        path: '/loading',
        builder: (context, state) => const LoadingPage(),
      ),
    ],
  );
}
