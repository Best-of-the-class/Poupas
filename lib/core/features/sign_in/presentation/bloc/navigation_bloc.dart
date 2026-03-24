import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../services/auth_service.dart';
import 'validator_bloc.dart';

abstract class NavigationEvent {}

class NavigateToNextStep extends NavigationEvent {
  final String routeName;
  final dynamic arguments;
  NavigateToNextStep({required this.routeName, this.arguments});
}

class EmitNavigationError extends NavigationEvent {
  final String message;
  EmitNavigationError(this.message);
}

abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationSideEffect extends NavigationState {
  final String routeName;
  final dynamic arguments;
  NavigationSideEffect({required this.routeName, this.arguments});
}

class NavigationErrorEffect extends NavigationState {
  final String message;
  NavigationErrorEffect(this.message);
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final ValidatorBloc validatorBloc;
  late StreamSubscription _validatorSubscription;
  String? _pendingRoute;

  final AuthService _authService = AuthService();

  NavigationBloc({required this.validatorBloc}) : super(NavigationInitial()) {
    _validatorSubscription = validatorBloc.stream.listen((vState) async {
      if (vState is ValidationSuccess && _pendingRoute != null) {
        if (_pendingRoute == 'home') {
          final data = vState.data;

          bool sucesso = await _authService.cadastrar(
            data.name,
            data.email,
            data.password!,
          );

          if (!sucesso) {
            add(
              EmitNavigationError(
                'Erro ao cadastrar. Verifique seus dados ou tente mais tarde.',
              ),
            );
            _pendingRoute = null;
            return;
          }
        }

        add(
          NavigateToNextStep(
            routeName: _pendingRoute!,
            arguments: vState
                .data
                .email,
          ),
        );
        _pendingRoute = null;
      } else if (vState is ValidationFailure) {
        add(EmitNavigationError(vState.message));
      }
    });

    on<NavigateToNextStep>((event, emit) {
      emit(
        NavigationSideEffect(
          routeName: event.routeName,
          arguments: event.arguments,
        ),
      );
      emit(NavigationInitial());
    });

    on<EmitNavigationError>((event, emit) {
      emit(NavigationErrorEffect(event.message));
      emit(NavigationInitial());
      validatorBloc.add(ClearValidationError());
    });
  }

  void requestStepOne(String route, String name, String email) {
    _pendingRoute = route;
    validatorBloc.add(ValidateStepOne(name: name, email: email));
  }

  void requestStepTwo(String route, String password, String confirmPassword) {
    _pendingRoute = route;
    validatorBloc.add(
      ValidateStepTwo(password: password, confirmPassword: confirmPassword),
    );
  }

  @override
  Future<void> close() {
    _validatorSubscription.cancel();
    return super.close();
  }
}
