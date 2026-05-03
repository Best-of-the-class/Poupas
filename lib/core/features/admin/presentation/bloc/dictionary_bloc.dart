import 'package:flutter_bloc/flutter_bloc.dart';
import '../entities/dictionary_term.dart';

abstract class DictionaryEvent {}

class AddTerm extends DictionaryEvent {
  final String term;
  final String definition;
  AddTerm({required this.term, required this.definition});
}

class EditTerm extends DictionaryEvent {
  final int index;
  final String term;
  final String definition;
  EditTerm({required this.index, required this.term, required this.definition});
}

class DeleteTerm extends DictionaryEvent {
  final int index;
  DeleteTerm(this.index);
}

class SearchTerms extends DictionaryEvent {
  final String query;
  SearchTerms(this.query);
}

class DictionaryState {
  final List<DictionaryTerm> allTerms;
  final List<DictionaryTerm> filteredTerms;
  final String searchQuery;

  const DictionaryState({
    this.allTerms = const [],
    this.filteredTerms = const [],
    this.searchQuery = '',
  });

  DictionaryState copyWith({
    List<DictionaryTerm>? allTerms,
    List<DictionaryTerm>? filteredTerms,
    String? searchQuery,
  }) {
    return DictionaryState(
      allTerms: allTerms ?? this.allTerms,
      filteredTerms: filteredTerms ?? this.filteredTerms,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  DictionaryBloc()
    : super(
        const DictionaryState(
          allTerms: [
            DictionaryTerm(
              title: 'Juros Simples',
              definition:
                  'Método de cálculo financeiro onde a taxa de juros incide apenas sobre o valor inicial.',
            ),
            DictionaryTerm(
              title: 'Juros Composto',
              definition:
                  'O interesse de cada período é somado ao capital para o cálculo de novos juros.',
            ),
            DictionaryTerm(
              title: 'Capital Inicial',
              definition:
                  'O valor principal investido ou emprestado antes da aplicação de juros.',
            ),
            DictionaryTerm(
              title: 'Margem de Lucro',
              definition:
                  'A diferença entre o valor da venda e os custos de produção ou aquisição.',
            ),
          ],
          filteredTerms: [
            DictionaryTerm(
              title: 'Juros Simples',
              definition:
                  'Método de cálculo financeiro onde a taxa de juros incide apenas sobre o valor inicial.',
            ),
            DictionaryTerm(
              title: 'Juros Composto',
              definition:
                  'O interesse de cada período é somado ao capital para o cálculo de novos juros.',
            ),
            DictionaryTerm(
              title: 'Capital Inicial',
              definition:
                  'O valor principal investido ou emprestado antes da aplicação de juros.',
            ),
            DictionaryTerm(
              title: 'Margem de Lucro',
              definition:
                  'A diferença entre o valor da venda e os custos de produção ou aquisição.',
            ),
          ],
        ),
      ) {
    on<AddTerm>(_onAdd);
    on<EditTerm>(_onEdit);
    on<DeleteTerm>(_onDelete);
    on<SearchTerms>(_onSearch);
  }

  List<DictionaryTerm> _applySearch(List<DictionaryTerm> terms, String query) {
    if (query.trim().isEmpty) return List.from(terms);
    return terms
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _onAdd(AddTerm event, Emitter<DictionaryState> emit) {
    final updated = List<DictionaryTerm>.from(state.allTerms)
      ..add(DictionaryTerm(title: event.term, definition: event.definition));
    emit(
      state.copyWith(
        allTerms: updated,
        filteredTerms: _applySearch(updated, state.searchQuery),
      ),
    );
  }

  void _onEdit(EditTerm event, Emitter<DictionaryState> emit) {
    if (event.index < 0 || event.index >= state.allTerms.length) return;
    final updated = List<DictionaryTerm>.from(state.allTerms);
    updated[event.index] = DictionaryTerm(
      title: event.term,
      definition: event.definition,
    );
    emit(
      state.copyWith(
        allTerms: updated,
        filteredTerms: _applySearch(updated, state.searchQuery),
      ),
    );
  }

  void _onDelete(DeleteTerm event, Emitter<DictionaryState> emit) {
    if (event.index < 0 || event.index >= state.allTerms.length) return;
    final updated = List<DictionaryTerm>.from(state.allTerms)
      ..removeAt(event.index);
    emit(
      state.copyWith(
        allTerms: updated,
        filteredTerms: _applySearch(updated, state.searchQuery),
      ),
    );
  }

  void _onSearch(SearchTerms event, Emitter<DictionaryState> emit) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredTerms: _applySearch(state.allTerms, event.query),
      ),
    );
  }
}
