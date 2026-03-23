import 'package:get_it/get_it.dart';
import 'package:pomo/core/features/sign_in/presentation/bloc/navigation_bloc.dart';
import 'package:pomo/core/features/sign_in/presentation/bloc/validator_bloc.dart';

export '../features/sign_in/presentation/bloc/navigation_bloc.dart';
export '../features/sign_in/presentation/bloc/validator_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => ValidatorBloc());
  sl.registerLazySingleton(
    () => NavigationBloc(validatorBloc: sl<ValidatorBloc>()),
  );
}
