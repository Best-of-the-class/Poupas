import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_injection.dart' as di;

class GlobalBlocProviders extends StatefulWidget {
  final Widget child;
  const GlobalBlocProviders({super.key, required this.child});

  @override
  State<GlobalBlocProviders> createState() => _GlobalBlocProvidersState();
}

class _GlobalBlocProvidersState extends State<GlobalBlocProviders> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = di.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider<di.ValidatorBloc>(
              create: (_) => di.sl<di.ValidatorBloc>(),
            ),
            BlocProvider<di.NavigationBloc>(
              create: (_) => di.sl<di.NavigationBloc>(),
            ),
          ],
          child: widget.child,
        );
      },
    );
  }
}
