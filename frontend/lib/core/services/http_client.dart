import 'dart:convert';
import 'package:app_egressos/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  final String baseUrl;
  final SharedPreferences prefs;

  HttpClient({
    required this.baseUrl,
    required this.prefs,
  });
  
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = prefs.getString(ApiConstants.tokenKey);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(
        uri,
        headers: _getHeaders(includeAuth: requiresAuth),
      );
      return response;
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: _getHeaders(includeAuth: requiresAuth),
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.put(
        uri,
        headers: _getHeaders(includeAuth: requiresAuth),
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(
        uri,
        headers: _getHeaders(includeAuth: requiresAuth),
      );
      return response;
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
