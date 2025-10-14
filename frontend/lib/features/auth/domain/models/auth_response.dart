import 'package:app_egressos/features/auth/domain/models/user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Aceita diferentes formatos de resposta e converte de forma segura
    final tokenCandidate = json['token'] ?? json['accessToken'] ?? (json['data'] is Map ? json['data']['token'] : null);
    if (tokenCandidate == null) {
      throw Exception('Resposta de autenticação inválida: token ausente');
    }

    final token = tokenCandidate.toString();

    dynamic userCandidate = json['user'] ?? json['usuario'] ?? (json['data'] is Map ? json['data']['user'] : null);
    if (userCandidate == null || userCandidate is! Map<String, dynamic>) {
      throw Exception('Resposta de autenticação inválida: usuário ausente ou com formato inesperado');
    }

    return AuthResponse(
      token: token,
      user: UserModel.fromJson(Map<String, dynamic>.from(userCandidate)),
    );
  }
}
