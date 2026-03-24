import 'dart:io';
import 'package:flutter/material.dart';
import 'core/providers/global_bloc_providers.dart';
import 'core/network/adapters/routes_adapter.dart';

void main() {
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
    );
  }
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
