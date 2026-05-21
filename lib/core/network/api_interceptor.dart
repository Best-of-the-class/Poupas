import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'URL_NAO_ENCONTRADA';

  Future<Map<String, String>> _buildHeaders({bool includeJson = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = <String, String>{'Accept': 'application/json'};

    if (includeJson) {
      headers['Content-Type'] = 'application/json';
    }

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  http.Client _createClient() {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    return IOClient(ioc);
  }

  Uri _buildUri(String endpoint) => Uri.parse('$baseUrl$endpoint');

  Future<http.Response> get(String endpoint) async {
    final client = _createClient();

    try {
      return await client.get(
        _buildUri(endpoint),
        headers: await _buildHeaders(includeJson: false),
      );
    } finally {
      client.close();
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = _buildUri(endpoint);
    debugPrint('Chamando URL: $url');

    final client = _createClient();

    try {
      return await client.post(
        url,
        headers: await _buildHeaders(),
        body: jsonEncode(body),
      );
    } finally {
      client.close();
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final client = _createClient();

    try {
      return await client.put(
        _buildUri(endpoint),
        headers: await _buildHeaders(),
        body: jsonEncode(body),
      );
    } finally {
      client.close();
    }
  }

  Future<http.Response> delete(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final client = _createClient();

    try {
      return await client.delete(
        _buildUri(endpoint),
        headers: await _buildHeaders(),
        body: jsonEncode(body),
      );
    } finally {
      client.close();
    }
  }
}
