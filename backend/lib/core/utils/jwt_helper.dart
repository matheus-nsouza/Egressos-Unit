import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtHelper {
  static const String _secretKey =
      'sua_chave_secreta_super_segura_aqui_mude_em_producao';

  static String generateToken(int userId, String email, {Duration? expiresIn}) {
    final jwt = JWT({
      'userId': userId,
      'email': email,
      'iat': DateTime.now().millisecondsSinceEpoch,
    });

    return jwt.sign(
      SecretKey(_secretKey),
      expiresIn: expiresIn ?? Duration(days: 7),
    );
  }

  static String generateRefreshToken(int userId, String email) {
    return generateToken(userId, email, expiresIn: Duration(days: 30));
  }

  static Map<String, dynamic> verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secretKey));
      return jwt.payload as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Token inválido ou expirado');
    }
  }

  static int? getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      return payload['userId'] as int?;
    } catch (e) {
      return null;
    }
  }
}
