import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/dictionary_term.dart';

abstract class DictionaryEvent {}

class FetchTerms extends DictionaryEvent {}

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
  final bool isLoading; 

  const DictionaryState({
    this.allTerms = const [],
    this.filteredTerms = const [],
    this.searchQuery = '',
    this.isLoading = false,
  });

  DictionaryState copyWith({
    List<DictionaryTerm>? allTerms,
    List<DictionaryTerm>? filteredTerms,
    String? searchQuery,
    bool? isLoading,
  }) {
    return DictionaryState(
      allTerms: allTerms ?? this.allTerms,
      filteredTerms: filteredTerms ?? this.filteredTerms,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  DictionaryBloc() : super(const DictionaryState()) {
    on<FetchTerms>(_onFetchTerms); 
    on<AddTerm>(_onAdd);
    on<EditTerm>(_onEdit);
    on<DeleteTerm>(_onDelete);
    on<SearchTerms>(_onSearch);
  }

  String get _apiUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    final baseUrl = envUrl ?? 'https://localhost:7141/api';
    return '$baseUrl/Dicionario';
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? ''; 
  }

  List<DictionaryTerm> _applySearch(List<DictionaryTerm> terms, String query) {
    if (query.trim().isEmpty) return List.from(terms);
    return terms
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> _onFetchTerms(FetchTerms event, Emitter<DictionaryState> emit) async {
    emit(state.copyWith(isLoading: true)); 
    
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        List jsonResponse = decodedData['dados']; 
        
        final fetchedTerms = jsonResponse.map((data) => DictionaryTerm.fromJson(data)).toList();
        
        emit(state.copyWith(
          isLoading: false,
          allTerms: fetchedTerms,
          filteredTerms: _applySearch(fetchedTerms, state.searchQuery),
        ));
      } else {
        print('ERRO NO GET DICIONÁRIO: ${response.statusCode} - ${response.body}');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO GET DICIONÁRIO: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAdd(AddTerm event, Emitter<DictionaryState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'termo': event.term,
          'definicao': event.definition 
        }),
      );

      if (response.statusCode == 201) {
        add(FetchTerms());
      } else {
        print('ERRO NO CREATE TERMO: ${response.statusCode} - ${response.body}');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO CREATE TERMO: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onEdit(EditTerm event, Emitter<DictionaryState> emit) async {
    if (event.index < 0 || event.index >= state.allTerms.length) return;
    
    emit(state.copyWith(isLoading: true));
    final idDaPalavra = state.allTerms[event.index].id;

    try {
      final token = await _getToken();

      final response = await http.put(
        Uri.parse('$_apiUrl/$idDaPalavra'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'termo': event.term,
          'definicao': event.definition
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        add(FetchTerms());
      } else {
        print('ERRO NO UPDATE TERMO: ${response.statusCode} - ${response.body}');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO UPDATE TERMO: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onDelete(DeleteTerm event, Emitter<DictionaryState> emit) async {
    if (event.index < 0 || event.index >= state.allTerms.length) return;
    
    emit(state.copyWith(isLoading: true));
    final idDaPalavra = state.allTerms[event.index].id;

    try {
      final token = await _getToken();

      final response = await http.delete(
        Uri.parse('$_apiUrl/$idDaPalavra'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        add(FetchTerms());
      } else {
         print('ERRO NO DELETE TERMO: ${response.statusCode} - ${response.body}');
         emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO DELETE TERMO: $e');
      emit(state.copyWith(isLoading: false));
    }
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