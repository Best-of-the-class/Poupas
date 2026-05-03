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

Future<void> init() async {
  sl.registerLazySingleton(() => ValidatorBloc());
  sl.registerLazySingleton(
    () => NavigationBloc(validatorBloc: sl<ValidatorBloc>()),
  );

  sl.registerLazySingleton(() => PasswordResetValidatorBloc());
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
