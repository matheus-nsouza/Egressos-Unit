import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:app_egressos/core/constants/api_constants.dart';
import 'package:app_egressos/core/services/http_client.dart';
import 'package:app_egressos/features/auth/domain/models/auth_response.dart';
import 'package:app_egressos/features/auth/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final HttpClient httpClient;
  final SharedPreferences prefs;
  final FirebaseAuth _firebaseAuth;

  AuthRepository({
    required this.httpClient,
    required this.prefs,
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Map<String, dynamic> _parseApiResponse(http.Response response, {List<int>? okStatusCodes}) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    okStatusCodes ??= [200, 201];

    if (!okStatusCodes.contains(response.statusCode)) {
      if (body is Map<String, dynamic>) {
        final error = body['error'] ?? body['message'] ?? 'Erro na requisição';
        throw Exception(error.toString());
      }
      throw Exception('Erro na requisição: status ${response.statusCode}');
    }

    if (body is Map<String, dynamic>) {
      if (body.containsKey('success')) {
        if (body['success'] == true) {
          return (body['data'] is Map<String, dynamic>) ? Map<String, dynamic>.from(body['data']) : {'value': body['data']};
        } else {
          final error = body['error'] ?? body['message'] ?? 'Erro na requisição';
          throw Exception(error.toString());
        }
      }
      
      return Map<String, dynamic>.from(body);
    }

    return {};
  }

  Future<AuthResponse> login(String cpf, String senha) async {
    final response = await httpClient.post(
      ApiConstants.authLogin,
      {'cpf': cpf, 'senha': senha},
    );

    final parsed = _parseApiResponse(response, okStatusCodes: [200]);
    final authResponse = AuthResponse.fromJson(parsed);

    await _saveAuthData(authResponse);

    return authResponse;
  }

  Future<AuthResponse> register({
    required String nomeCompleto,
    required String cpf,
    required String senha,
    String? fotoUrl,
  }) async {
    final response = await httpClient.post(
      ApiConstants.authRegister,
      {
        'nomeCompleto': nomeCompleto,
        'cpf': cpf,
        'senha': senha,
        'confirmacaoSenha': senha,
        if (fotoUrl != null) 'fotoUrl': fotoUrl,
      },
    );

    final parsed = _parseApiResponse(response, okStatusCodes: [201]);
    final authResponse = AuthResponse.fromJson(parsed);

    await _saveAuthData(authResponse);

    return authResponse;
  }

  Future<UserModel> getCurrentUser() async {
    final response = await httpClient.get(
      ApiConstants.authMe,
      requiresAuth: true,
    );

    final parsed = _parseApiResponse(response, okStatusCodes: [200]);
    return UserModel.fromJson(parsed);
  }

  Future<void> changePassword(String senhaAtual, String novaSenha) async {
    final response = await httpClient.post(
      ApiConstants.authChangePassword,
      {
        'senhaAtual': senhaAtual,
        'novaSenha': novaSenha,
      },
      requiresAuth: true,
    );

    _parseApiResponse(response, okStatusCodes: [200]);
  }

  Future<String> refreshToken() async {
    final response = await httpClient.post(
      ApiConstants.authRefreshToken,
      {},
      requiresAuth: true,
    );

    final parsed = _parseApiResponse(response, okStatusCodes: [200]);
    final newToken = parsed['token']?.toString() ?? '';

    if (newToken.isEmpty) throw Exception('Token inválido retornado');

    await prefs.setString(ApiConstants.tokenKey, newToken);

    return newToken;
  }

  Future<void> logout() async {
    try {
      await httpClient.post(
        ApiConstants.authLogout,
        {},
        requiresAuth: true,
      );
    } catch (e) {
      // Ignorar erros de logout no servidor
    } finally {
      await _clearAuthData();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );
      // Firebase envia o email automaticamente
      return;
    } on FirebaseAuthException catch (e) {
      // Mapear erros do Firebase para mensagens amigáveis
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      throw Exception('Erro ao enviar email de recuperação: $e');
    }
  }

  Future<void> resetPassword(String token, String novaSenha) async {
    final response = await httpClient.post(
      ApiConstants.authResetPassword,
      {
        'token': token,
        'novaSenha': novaSenha,
      },
    );

    _parseApiResponse(response, okStatusCodes: [200]);
  }

  Future<bool> isLoggedIn() async {
    final token = prefs.getString(ApiConstants.tokenKey);
    if (token == null) return false;

    try {
      await getCurrentUser();
      return true;
    } catch (e) {
      await _clearAuthData();
      return false;
    }
  }

  UserModel? getSavedUser() {
    final userData = prefs.getString(ApiConstants.userKey);
    if (userData == null) return null;

    try {
      final json = jsonDecode(userData);
      return UserModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await prefs.setString(ApiConstants.tokenKey, authResponse.token);
    await prefs.setString(
      ApiConstants.userKey,
      jsonEncode(authResponse.user.toJson()),
    );
  }

  Future<void> _clearAuthData() async {
    await prefs.remove(ApiConstants.tokenKey);
    await prefs.remove(ApiConstants.userKey);
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'E-mail inválido. Verifique o formato.';
      case 'user-not-found':
        return 'Não encontramos uma conta com este e-mail.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      default:
        return 'Erro ao enviar email de recuperação. Tente novamente.';
    }
  }
}