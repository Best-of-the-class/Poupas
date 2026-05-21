import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import '../../models/dictionary_term.dart'; 
import 'flashcard/dicionario_flashcard.dart';

class DicionarioContent extends StatefulWidget {
  const DicionarioContent({super.key});

  @override
  State<DicionarioContent> createState() => _DicionarioContentState();
}

class _DicionarioContentState extends State<DicionarioContent> {
  late Future<List<DictionaryTerm>> futureTerms;

  @override
  void initState() {
    super.initState();
    futureTerms = fetchDicionario();
  }

  Future<List<DictionaryTerm>> fetchDicionario() async {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://localhost:7141/api';
    final url = Uri.parse('$baseUrl/Dicionario');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        List jsonResponse = decodedData['dados']; 
        
        return jsonResponse.map((data) => DictionaryTerm.fromJson(data)).toList();
      } else {
        debugPrint('Erro na API: ${response.statusCode} - ${response.body}');
        throw Exception('Erro ${response.statusCode}: Não foi possível carregar os dados.');
      }
    } catch (e) {
      debugPrint('Erro de conexão: $e');
      throw Exception('Falha de conexão com o servidor.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Sempre que estiver em dúvida sobre alguma palavra, consulte o dicionário de termos. Toque nos flashcards abaixo e veja o significado.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: FutureBuilder<List<DictionaryTerm>>(
                future: futureTerms,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: AppColors.primary);
                  } else if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      'O dicionário ainda está vazio.',
                      style: AppTextStyles.body.copyWith(color: AppColors.textDark),
                    );
                  }
                  return DicionarioFlashcard(terms: snapshot.data!);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}