import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_injection.dart';

class GlobalBlocProviders extends StatelessWidget {
  final Widget child;
  const GlobalBlocProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ValidatorBloc>.value(value: sl<ValidatorBloc>()),
        BlocProvider<PasswordResetValidatorBloc>.value(
          value: sl<PasswordResetValidatorBloc>(),
        ),
        BlocProvider<NavigationBloc>.value(value: sl<NavigationBloc>()),
        BlocProvider<ForgotPasswordNavigationBloc>.value(
          value: sl<ForgotPasswordNavigationBloc>(),
        ),
        BlocProvider<LessonTitleValidatorBloc>.value(
          value: sl<LessonTitleValidatorBloc>(),
        ),
        BlocProvider<AdminNavigationBloc>.value(
          value: sl<AdminNavigationBloc>(),
        ),
        BlocProvider<AdminQuestionsBloc>.value(value: sl<AdminQuestionsBloc>()),
        BlocProvider<LessonBloc>.value(value: sl<LessonBloc>()),
        BlocProvider<DictionaryBloc>.value(value: sl<DictionaryBloc>()),
        BlocProvider<DictionaryValidatorBloc>.value(
          value: sl<DictionaryValidatorBloc>(),
        ),
      ],
      child: child,
    );
  }
}
