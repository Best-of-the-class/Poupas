import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'validator_bloc.dart';
import '../../../sign_in/presentation/bloc/validator_bloc.dart';

abstract class ForgotPasswordNavigationEvent {}

class ForgotNavigateToNextStep extends ForgotPasswordNavigationEvent {
  final String routeName;
  final dynamic arguments;
  ForgotNavigateToNextStep({required this.routeName, this.arguments});
}

class ForgotEmitNavigationError extends ForgotPasswordNavigationEvent {
  final String message;
  ForgotEmitNavigationError(this.message);
}

abstract class ForgotPasswordNavigationState {}

class ForgotNavigationInitial extends ForgotPasswordNavigationState {}

class ForgotNavigationSideEffect extends ForgotPasswordNavigationState {
  final String routeName;
  final dynamic arguments;
  final int id;
  ForgotNavigationSideEffect({required this.routeName, this.arguments})
    : id = DateTime.now().microsecondsSinceEpoch;
}

class ForgotNavigationErrorEffect extends ForgotPasswordNavigationState {
  final String message;
  final int id;
  ForgotNavigationErrorEffect(this.message)
    : id = DateTime.now().microsecondsSinceEpoch;
}

class ForgotPasswordNavigationBloc
    extends Bloc<ForgotPasswordNavigationEvent, ForgotPasswordNavigationState> {
  final PasswordResetValidatorBloc _resetValidatorBloc;
  late final StreamSubscription _subscription;
  String? _pendingRoute;

  bool isDialogOpen = false;

  ForgotPasswordNavigationBloc({
    required PasswordResetValidatorBloc validatorBloc,
  }) : _resetValidatorBloc = validatorBloc,
       super(ForgotNavigationInitial()) {
    on<ForgotNavigateToNextStep>((event, emit) {
      emit(
        ForgotNavigationSideEffect(
          routeName: event.routeName,
          arguments: event.arguments,
        ),
      );
    });

    on<ForgotEmitNavigationError>((event, emit) {
      emit(ForgotNavigationErrorEffect(event.message));
    });

    _subscription = _resetValidatorBloc.stream.listen((vState) {
      if (vState is ValidationSuccess) {
        if (_pendingRoute != null) {
          final route = _pendingRoute!;
          _pendingRoute = null;
          add(
            ForgotNavigateToNextStep(routeName: route, arguments: vState.data),
          );
        }
      } else if (vState is ValidationFailure) {
        _pendingRoute = null;
        add(ForgotEmitNavigationError(vState.message));
      }
    });
  }

  void _resetValidator() {
    _resetValidatorBloc.add(ResetValidation());
  }

  void requestResetStepOne(String route, String email) {
    _pendingRoute = route;
    _resetValidator();
    _resetValidatorBloc.add(ValidateEmailStep(email));
  }

  void requestResetStepTwo(String route, String code) {
    _pendingRoute = route;
    _resetValidator();
    _resetValidatorBloc.add(ValidateCodeStep(code));
  }

  void requestResetStepThree(
    String route,
    String password,
    String confirmPassword,
  ) {
    _pendingRoute = route;
    _resetValidator();
    _resetValidatorBloc.add(
      ValidatePasswordStep(
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
