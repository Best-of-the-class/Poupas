import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'validator_bloc.dart';

abstract class NavigationEvent {}
class NavigateToNextStep extends NavigationEvent {
  final String routeName;
  final dynamic arguments;
  NavigateToNextStep({required this.routeName, this.arguments});
}

abstract class NavigationState {}
class NavigationInitial extends NavigationState {}
class NavigationSideEffect extends NavigationState {
  final String routeName;
  final dynamic arguments;
  NavigationSideEffect({required this.routeName, this.arguments});
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final ValidatorBloc validatorBloc;
  late StreamSubscription _validatorSubscription;
  String? _pendingRoute;

  NavigationBloc({required this.validatorBloc}) : super(NavigationInitial()) {
    
    _validatorSubscription = validatorBloc.stream.listen((validatorState) {
      if (validatorState is ValidationSuccess && _pendingRoute != null) {
        add(NavigateToNextStep(
          routeName: _pendingRoute!, 
          arguments: validatorState.data
        ));
        _pendingRoute = null;
      }
    });

    on<NavigateToNextStep>((event, emit) {
      emit(NavigationSideEffect(
        routeName: event.routeName,
        arguments: event.arguments,
      ));
      emit(NavigationInitial());
    });
  }

  void requestNavigation(String route, String data, String type) {
    _pendingRoute = route;
    validatorBloc.add(ValidateStep(data, type));
  }

  @override
  Future<void> close() {
    _validatorSubscription.cancel();
    return super.close();
  }
}