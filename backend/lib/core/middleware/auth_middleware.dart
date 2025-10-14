import 'dart:convert';
import 'package:backend/core/utils/jwt_helper.dart';
import 'package:shelf/shelf.dart';

Middleware authMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.unauthorized(
          jsonEncode({'success': false, 'error': 'Token não fornecido'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      try {
        final token = authHeader.substring(7);

        final payload = JwtHelper.verifyToken(token);

        final updatedRequest = request.change(
          context: {
            'userId': payload['userId'],
            'email': payload['email'],
          },
        );

        return await handler(updatedRequest);
      } catch (e) {
        return Response.unauthorized(
          jsonEncode({'success': false, 'error': 'Token inválido ou expirado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}

Middleware roleMiddleware(List<String> requiredRoles) {
  return (Handler handler) {
    return (Request request) async {
      final userRole = request.context['role'] as String?;

      if (userRole == null || !requiredRoles.contains(userRole)) {
        return Response.forbidden(
          jsonEncode({
            'success': false,
            'error': 'Acesso negado: permissões insuficientes'
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return await handler(request);
    };
  };
}
