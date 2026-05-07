import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomo/core/theme/app_theme.dart';
import 'core/providers/bloc_injection.dart';
import 'core/providers/global_bloc_providers.dart';
import 'core/network/adapters/routes_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final String? tipo = prefs.getString('tipo');

  String rotaInicial = '/loadingWelcome';

  if (token != null && token.isNotEmpty) {
    if (tipo?.toLowerCase() == 'admin') {
      rotaInicial = '/admin-activities';
    } else {
      rotaInicial = '/home';
    }
  }

  RoutesAdapter.initialLocation = rotaInicial;

  runApp(const GlobalBlocProviders(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Poupas',
      debugShowCheckedModeBanner: false,
      routerConfig: RoutesAdapter.router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      theme: AppTheme.lightTheme,
    );
  }
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}