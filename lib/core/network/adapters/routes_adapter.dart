import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/sign_in/presentation/pages/sign_in_password_page.dart';
import '../../features/sign_in/presentation/pages/sign_in_page.dart';

class RoutesAdapter {
  static const String signIn = 'sign-in';
  static const String signInPassword = 'sign-in-password';
  static const String home = 'home';

  static final GoRouter router = GoRouter(
    initialLocation: '/signIn', 
    // ^^^^ mudar para home e matar minha home falsa de teste
    routes: [
      GoRoute(
        name: signIn,
        path: '/signIn',
        builder: (context, state) => const SignInPage(),
      ), 
      GoRoute(
        name: signInPassword,
        path: '/signInPassword',
        builder: (context, state) => SignInPagePassword(email: state.extra as String),
      ),
      // pode matar essa home quando a inicial tiver feita 
      GoRoute(
        name: home,
        path: '/home',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home uepa!!!'))),
      ),
    ],
  );
}