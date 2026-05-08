import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/module.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class LessonEvent {}
class LoadLessons extends LessonEvent {}

class CreateLesson extends LessonEvent {
  final int dificuldade;
  final String tituloLicao;
  final String textoConceito;
  final List<Map<String, dynamic>> questoes;

  CreateLesson({
    required this.dificuldade,
    required this.tituloLicao,
    required this.textoConceito,
    required this.questoes,
  });
}

class LoadLessonDetails extends LessonEvent {
  final String titulo;
  LoadLessonDetails(this.titulo);
}

class UpdateLesson extends LessonEvent {
  final String tituloAntigo;
  final int dificuldade;
  final String tituloLicao;
  final String textoConceito;
  final List<Map<String, dynamic>> questoes;

  UpdateLesson({
    required this.tituloAntigo,
    required this.dificuldade,
    required this.tituloLicao,
    required this.textoConceito,
    required this.questoes,
  });
}

class DeleteLesson extends LessonEvent {
  final ModuleDifficulty difficulty;
  final int index;
  DeleteLesson(this.difficulty, this.index);
}

class LessonState {
  final Map<ModuleDifficulty, List<String>> lessonsByDifficulty;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic>? lessonDetails;

  const LessonState({
    required this.lessonsByDifficulty,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.lessonDetails,
  });

  factory LessonState.initial() {
    return const LessonState(
      lessonsByDifficulty: {
        ModuleDifficulty.easy: [],
        ModuleDifficulty.medium: [],
        ModuleDifficulty.hard: [],
      },
    );
  }

  LessonState copyWith({
    Map<ModuleDifficulty, List<String>>? lessonsByDifficulty,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Map<String, dynamic>? lessonDetails,
  }) {
    return LessonState(
      lessonsByDifficulty: lessonsByDifficulty ?? this.lessonsByDifficulty,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      lessonDetails: lessonDetails ?? this.lessonDetails,
    );
  }
}

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc() : super(LessonState.initial()) {
    on<LoadLessons>(_onLoadLessons);
    on<CreateLesson>(_onCreate);
    on<DeleteLesson>(_onDelete);
    on<LoadLessonDetails>(_onLoadDetails);
    on<UpdateLesson>(_onUpdate);
  }

  String get _baseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    return envUrl ?? 'https://localhost:7141/api';
  }

  Future<void> _onCreate(CreateLesson event, Emitter<LessonState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));
    final url = Uri.parse('$_baseUrl/Licao/criar');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "dificuldade": event.dificuldade,
          "tituloLicao": event.tituloLicao,
          "textoConceito": event.textoConceito,
          "questoes": event.questoes
        }),
      );

      if (response.statusCode == 200) {
        final updated = Map<ModuleDifficulty, List<String>>.from(state.lessonsByDifficulty);
        final difficultyEnum = ModuleDifficulty.values[event.dificuldade - 1];
        updated[difficultyEnum] = List<String>.from(updated[difficultyEnum] ?? [])..add(event.tituloLicao);
        
        emit(state.copyWith(lessonsByDifficulty: updated, isLoading: false, isSuccess: true));
      } else {
        print('ERRO NO CREATE: ${response.statusCode} - ${response.body}');
        emit(state.copyWith(isLoading: false, errorMessage: "Erro do Servidor: ${response.body}"));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO CREATE: $e');
      emit(state.copyWith(isLoading: false, errorMessage: "Falha de conexão: $e"));
    }
  }

  Future<void> _onDelete(DeleteLesson event, Emitter<LessonState> emit) async {
    final updated = Map<ModuleDifficulty, List<String>>.from(state.lessonsByDifficulty);
    final list = List<String>.from(updated[event.difficulty] ?? []);

    if (event.index < 0 || event.index >= list.length) return;
    
    final tituloParaDeletar = list[event.index];
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final url = Uri.parse('$_baseUrl/Licao/deletar/${Uri.encodeComponent(tituloParaDeletar)}');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        list.removeAt(event.index);
        updated[event.difficulty] = list;
        emit(state.copyWith(lessonsByDifficulty: updated, isLoading: false));
      } else {
        print('ERRO NO DELETE: ${response.statusCode} - ${response.body}');
        emit(state.copyWith(isLoading: false, errorMessage: "Erro ao deletar: ${response.body}"));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO DELETE: $e');
      emit(state.copyWith(isLoading: false, errorMessage: "Falha ao conectar: $e"));
    }
  }

  Future<void> _onLoadLessons(LoadLessons event, Emitter<LessonState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final url = Uri.parse('$_baseUrl/Licao/listar');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        Map<ModuleDifficulty, List<String>> fetchedLessons = {
          ModuleDifficulty.easy: [], ModuleDifficulty.medium: [], ModuleDifficulty.hard: [],
        };

        for (var modulo in data) {
          int dificuldade = modulo['dificuldade'];
          List<String> licoes = List<String>.from(modulo['licoes']);
          ModuleDifficulty difEnum = ModuleDifficulty.values[dificuldade - 1];
          fetchedLessons[difEnum] = licoes;
        }

        emit(state.copyWith(lessonsByDifficulty: fetchedLessons, isLoading: false));
      } else {
        print('ERRO NO GET AULAS: ${response.statusCode}');
        emit(state.copyWith(isLoading: false, errorMessage: "Erro ao buscar aulas."));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO GET AULAS: $e');
      emit(state.copyWith(isLoading: false, errorMessage: "Falha de conexão: $e"));
    }
  }

  Future<void> _onLoadDetails(LoadLessonDetails event, Emitter<LessonState> emit) async {
    emit(LessonState(
      lessonsByDifficulty: state.lessonsByDifficulty,
      isLoading: true,
      isSuccess: false,
      lessonDetails: null, 
    ));
    
    final url = Uri.parse('$_baseUrl/Licao/detalhes/${Uri.encodeComponent(event.titulo)}');

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(state.copyWith(isLoading: false, lessonDetails: data));
      } else {
        print('ERRO NO GET DETALHES: ${response.statusCode} - ${response.body}');
        emit(state.copyWith(isLoading: false, errorMessage: "Erro ao buscar detalhes."));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO GET DETALHES: $e');
      emit(state.copyWith(isLoading: false, errorMessage: "Falha de conexão: $e"));
    }
  }

  Future<void> _onUpdate(UpdateLesson event, Emitter<LessonState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    final url = Uri.parse('$_baseUrl/Licao/editar/${Uri.encodeComponent(event.tituloAntigo)}');

    try {
      final response = await http.put(
        url, 
        headers: {"Content-Type": "application/json"}, 
        body: jsonEncode({
          "dificuldade": event.dificuldade,
          "tituloLicao": event.tituloLicao,
          "textoConceito": event.textoConceito,
          "questoes": event.questoes,
        })
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(LoadLessons()); 
      } else {
        print('ERRO NO UPDATE: ${response.statusCode} - ${response.body}');
        emit(state.copyWith(isLoading: false, errorMessage: "Erro ao atualizar: ${response.body}"));
      }
    } catch (e) {
      print('ERRO DE CONEXÃO NO UPDATE: $e');
      emit(state.copyWith(isLoading: false, errorMessage: "Falha de conexão: $e"));
    }
  }
}