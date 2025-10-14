import 'dart:convert';
import 'package:shelf/shelf.dart';

class ResponseUtils {
  static Response success(dynamic data, {String? message, int status = 200}) {
    return Response(
      status,
      body: jsonEncode({
        'success': true,
        if (message != null) 'message': message,
        'data': data is Map && data.containsKey('data') ? data['data'] : data,
        if (data is Map && data.containsKey('meta')) 'meta': data['meta'],
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response error(String message, {int status = 500}) {
    return Response(
      status,
      body: jsonEncode({
        'success': false,
        'error': message,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response badRequest(String message) {
    return error(message, status: 400);
  }

  static Response unauthorized(String message) {
    return error(message, status: 401);
  }

  static Response forbidden(String message) {
    return error(message, status: 403);
  }

  static Response notFound(String message) {
    return error(message, status: 404);
  }

  static Response conflict(String message) {
    return error(message, status: 409);
  }

  static Response unprocessableEntity(Map<String, dynamic> errors) {
    return Response(
      422,
      body: jsonEncode({
        'success': false,
        'errors': errors,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
