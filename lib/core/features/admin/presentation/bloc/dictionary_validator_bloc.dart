import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DictionaryValidatorEvent {}

class ValidateTerm extends DictionaryValidatorEvent {
  final String term;
  final String definition;
  final String? originalTerm;
  final String? originalDefinition;
  ValidateTerm({
    required this.term,
    required this.definition,
    this.originalTerm,
    this.originalDefinition,
  });
}

class ResetTermValidation extends DictionaryValidatorEvent {}

abstract class DictionaryValidatorState {}

class TermInitial extends DictionaryValidatorState {}

class TermSuccess extends DictionaryValidatorState {
  final String term;
  final String definition;
  final bool isEditing;
  TermSuccess({
    required this.term,
    required this.definition,
    required this.isEditing,
  });
}

class TermFailureEffect extends DictionaryValidatorState {
  final String message;
  final int id;
  TermFailureEffect(this.message) : id = DateTime.now().microsecondsSinceEpoch;
}

class DictionaryValidatorBloc
    extends Bloc<DictionaryValidatorEvent, DictionaryValidatorState> {
  static const int maxTermLength = 60;

  DictionaryValidatorBloc() : super(TermInitial()) {
    on<ResetTermValidation>((event, emit) => emit(TermInitial()));

    on<ValidateTerm>((event, emit) {
      final term = event.term.trim();
      final definition = event.definition.trim();
      final isEditing = event.originalTerm != null;

      if (term.isEmpty) {
        emit(TermFailureEffect('O nome do termo não pode estar vazio.'));
      } else if (term.length > maxTermLength) {
        emit(
          TermFailureEffect(
            'O termo deve ter no máximo $maxTermLength caracteres.',
          ),
        );
      } else if (definition.isEmpty) {
        emit(TermFailureEffect('A definição do termo não pode estar vazia.'));
      } else if (isEditing &&
          term == event.originalTerm?.trim() &&
          definition == event.originalDefinition?.trim()) {
        emit(TermFailureEffect('Nenhuma alteração foi feita no termo.'));
      } else {
        emit(
          TermSuccess(term: term, definition: definition, isEditing: isEditing),
        );
      }
    });
  }
}
