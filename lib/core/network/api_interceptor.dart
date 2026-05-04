import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart'; 

class ApiInterceptor {

  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'URL_NAO_ENCONTRADA';

  Future<http.Response> get(String endpoint, {Map<String, String>? queryParameters}) async {
    var url = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null) {
      url = url.replace(queryParameters: queryParameters);
    }
    
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http.Client client = IOClient(ioc);

    try {
      return await client.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
    } finally {
      client.close(); 
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('Chamando URL: $url');
    
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http.Client client = IOClient(ioc);

    try {
      return await client.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );
    } finally {
      client.close(); 
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http.Client client = IOClient(ioc);

    try {
      return await client.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );
    } finally {
      client.close(); 
    }
  }

  // metodos put e delete adicionados pelo back *Amanda
  Future<http.Response> delete(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http.Client client = IOClient(ioc);

    try {
      return await client.delete(
        url,
        headers: {
          "Content-Type": "application/json", 
          "Accept": "application/json"
        },
        body: jsonEncode(body),
      );
    } finally {
      client.close(); 
    }
  }
}
