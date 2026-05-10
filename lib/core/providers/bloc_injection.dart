import 'dart:ffi';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:pomo/core/features/sign_in/presentation/bloc/navigation_bloc.dart';
import 'package:pomo/core/features/sign_in/presentation/bloc/validator_bloc.dart';
import 'package:pomo/core/features/forgot_password/presentation/bloc/navigation_bloc.dart';
import 'package:pomo/core/features/forgot_password/presentation/bloc/validator_bloc.dart';
import 'package:pomo/core/features/admin/presentation/bloc/question_bloc.dart';
import 'package:pomo/core/features/admin/presentation/bloc/lesson_bloc.dart';
import 'package:pomo/core/features/admin/presentation/bloc/validator_bloc.dart';
import 'package:pomo/core/features/admin/presentation/bloc/navigator_bloc.dart';
import 'package:pomo/core/features/admin/presentation/bloc/dictionary_bloc.dart';
import 'package:pomo/core/features/admin/presentation/bloc/dictionary_validator_bloc.dart';

import 'package:pomo/core/network/adapters/go_adapter.dart';
import 'package:pomo/services/auth_service.dart';

export 'package:pomo/core/features/sign_in/presentation/bloc/navigation_bloc.dart';
export 'package:pomo/core/features/sign_in/presentation/bloc/validator_bloc.dart';
export 'package:pomo/core/features/forgot_password/presentation/bloc/navigation_bloc.dart';
export 'package:pomo/core/features/forgot_password/presentation/bloc/validator_bloc.dart';
export 'package:pomo/core/features/admin/presentation/bloc/question_bloc.dart';
export 'package:pomo/core/features/admin/presentation/bloc/lesson_bloc.dart';
export 'package:pomo/core/features/admin/presentation/bloc/validator_bloc.dart';
export 'package:pomo/core/features/admin/presentation/bloc/navigator_bloc.dart';
export 'package:pomo/core/features/admin/presentation/bloc/dictionary_bloc.dart';
export 'package:pomo/core/features/admin/presentation/bloc/dictionary_validator_bloc.dart';

final sl = GetIt.instance;

DynamicLibrary _loadGoLib() {
  if (Platform.isAndroid) return DynamicLibrary.open('libgo_security.so');
  if (Platform.isWindows) return DynamicLibrary.open('go_security.dll');
  if (Platform.isMacOS) return DynamicLibrary.open('libgo_security.dylib');
  if (Platform.isLinux) return DynamicLibrary.open('libgo_security.so');
  if (Platform.isIOS) return DynamicLibrary.process();
  throw UnsupportedError(
    'Plataforma não suportada: ${Platform.operatingSystem}',
  );
}

Future<void> init() async {
  sl.registerLazySingleton<GoSecurityAdapter>(
    () => GoSecurityAdapter(_loadGoLib()),
  );

  sl.registerLazySingleton(() => ValidatorBloc());

  sl.registerLazySingleton(() => AuthService(sl<GoSecurityAdapter>()));

  sl.registerLazySingleton(
    () => NavigationBloc(
      validatorBloc: sl<ValidatorBloc>(),
      authService: sl<AuthService>(),
    ),
  );

  sl.registerLazySingleton(() => PasswordResetValidatorBloc(sl<AuthService>()));

  sl.registerLazySingleton(
    () => ForgotPasswordNavigationBloc(
      validatorBloc: sl<PasswordResetValidatorBloc>(),
    ),
  );

  sl.registerLazySingleton(() => LessonTitleValidatorBloc());

  sl.registerLazySingleton(
    () => AdminNavigationBloc(validatorBloc: sl<LessonTitleValidatorBloc>()),
  );

  sl.registerLazySingleton(() => AdminQuestionsBloc());
  sl.registerLazySingleton(() => LessonBloc());
  sl.registerLazySingleton(() => DictionaryBloc());
  sl.registerLazySingleton(() => DictionaryValidatorBloc());
}
