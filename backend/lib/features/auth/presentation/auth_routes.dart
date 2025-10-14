import 'dart:convert';
import 'package:backend/features/auth/data/auth_repository.dart';
import 'package:backend/features/auth/domain/login_request.dart';
import 'package:backend/features/auth/domain/models/register_request.dart';
import 'package:backend/features/auth/domain/models/change_password_request.dart';
import 'package:backend/features/auth/domain/validators/auth_validators.dart';
import 'package:backend/core/utils/response_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRoutes {
  final AuthRepository _repository = AuthRepository();

  Router get router {
    final router = Router();

    router.post('/register', _register);
    router.post('/login', _login);
    router.post('/forgot-password', _forgotPassword);
    router.post('/reset-password', _resetPassword);

    router.get('/me', _getCurrentUser);
    router.post('/change-password', _changePassword);
    router.post('/refresh-token', _refreshToken);
    router.post('/logout', _logout);

    return router;
  }

  Future<Response> _register(Request req) async {
    try {
      final contentType = req.headers['content-type']?.toLowerCase() ?? '';
      final body = await req.readAsString();

      Map<String, dynamic> data;

      if (contentType.startsWith('multipart/form-data')) {
        final boundaryMatch = RegExp(r'boundary=(.*)').firstMatch(contentType);
        final boundary =
            boundaryMatch != null ? boundaryMatch.group(1) ?? '' : '';
        data = _parseMultipartForm(body, boundary);
      } else if (contentType.startsWith('application/x-www-form-urlencoded')) {
        final parsed = Uri.splitQueryString(body);
        data = parsed.map((k, v) => MapEntry(k, v));
      } else {
        data = jsonDecode(body) as Map<String, dynamic>;
      }

      final errors = AuthValidators.validateRegister(
        nomeCompleto: data['nomeCompleto'],
        cpf: data['cpf'],
        email: data['email'],
        senha: data['senha'],
        confirmacaoSenha: data['confirmacaoSenha'],
      );

      if (errors.isNotEmpty) {
        return ResponseUtils.badRequest(
          'Dados inválidos: ${errors.values.join(', ')}',
        );
      }

      final request = RegisterRequest.fromJson(data);

      final response = await _repository.register(request);

      return ResponseUtils.success(
        response.toJson(),
        message: 'Usuário registrado com sucesso',
        status: 201,
      );
    } catch (e) {
      if (e.toString().contains('já cadastrado')) {
        return ResponseUtils.conflict('Email já cadastrado');
      }
      return ResponseUtils.error('Erro ao registrar: $e');
    }
  }

  // TODO: Validar metodo De login
  Future<Response> _login(Request req) async {
    try {
      final contentType = req.headers['content-type']?.toLowerCase() ?? '';
      final body = await req.readAsString();

      Map<String, dynamic> data;

      if (contentType.startsWith('multipart/form-data')) {
        // Extrai boundary
        final boundaryMatch = RegExp(r'boundary=(.*)').firstMatch(contentType);
        final boundary =
            boundaryMatch != null ? boundaryMatch.group(1) ?? '' : '';
        data = _parseMultipartForm(body, boundary);
      } else if (contentType.startsWith('application/x-www-form-urlencoded')) {
        final parsed = Uri.splitQueryString(body);
        data = parsed.map((k, v) => MapEntry(k, v));
      } else {
        data = jsonDecode(body) as Map<String, dynamic>;
      }

      final errors = AuthValidators.validateLogin(
        cpf: data['cpf'],
        senha: data['senha'],
      );

      if (errors.isNotEmpty) {
        return ResponseUtils.badRequest(
          'Dados inválidos: ${errors.values.join(', ')}',
        );
      }

      final request = LoginRequest.fromJson(data);

      final response = await _repository.login(request);

      if (response == null) {
        return ResponseUtils.unauthorized('CPF ou senha incorretos');
      }

      return ResponseUtils.success(
        response.toJson(),
        message: 'Login realizado com sucesso',
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao fazer login: $e');
    }
  }

  Future<Response> _getCurrentUser(Request req) async {
    try {
      final userId = req.context['userId'] as int?;

      if (userId == null) {
        return ResponseUtils.unauthorized('Token inválido');
      }

      final user = await _repository.getCurrentUser(userId);

      if (user == null) {
        return ResponseUtils.notFound('Usuário não encontrado');
      }

      return ResponseUtils.success(user);
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar usuário: $e');
    }
  }

  Future<Response> _changePassword(Request req) async {
    try {
      final userId = req.context['userId'] as int?;

      if (userId == null) {
        return ResponseUtils.unauthorized('Token inválido');
      }

      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final request = ChangePasswordRequest.fromJson(data);

      final senhaError = AuthValidators.validatePassword(request.novaSenha);
      if (senhaError != null) {
        return ResponseUtils.badRequest(senhaError);
      }

      final success = await _repository.changePassword(
        userId,
        request.senhaAtual,
        request.novaSenha,
      );

      if (!success) {
        return ResponseUtils.badRequest('Senha atual incorreta');
      }

      return ResponseUtils.success(
        null,
        message: 'Senha alterada com sucesso',
      );
    } catch (e) {
      if (e.toString().contains('incorreta')) {
        return ResponseUtils.badRequest('Senha atual incorreta');
      }
      return ResponseUtils.error('Erro ao alterar senha: $e');
    }
  }

  Future<Response> _refreshToken(Request req) async {
    try {
      final authHeader = req.headers['authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return ResponseUtils.unauthorized('Token não fornecido');
      }

      final oldToken = authHeader.substring(7);
      final newToken = await _repository.refreshToken(oldToken);

      if (newToken == null) {
        return ResponseUtils.unauthorized('Token inválido');
      }

      return ResponseUtils.success({'token': newToken});
    } catch (e) {
      return ResponseUtils.error('Erro ao renovar token: $e');
    }
  }

  Future<Response> _logout(Request req) async {
    try {
      final authHeader = req.headers['authorization'];

      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);
        await _repository.logout(token);
      }

      return ResponseUtils.success(
        null,
        message: 'Logout realizado com sucesso',
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao fazer logout: $e');
    }
  }

  Future<Response> _forgotPassword(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final email = data['email'] as String?;

      final emailError = AuthValidators.validateEmail(email);
      if (emailError != null) {
        return ResponseUtils.badRequest(emailError);
      }

      final resetToken = await _repository.forgotPassword(email!);

      if (resetToken == null) {
        return ResponseUtils.success(
          null,
          message:
              'Se o email existir, você receberá instruções para resetar a senha',
        );
      }

      // TODO: Enviar email com link de reset
      // Por enquanto, retorne o token (apenas para desenvolvimento)
      return ResponseUtils.success(
        {'resetToken': resetToken},
        message: 'Token de reset gerado',
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao processar solicitação: $e');
    }
  }

  Future<Response> _resetPassword(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final token = data['token'] as String?;
      final novaSenha = data['novaSenha'] as String?;

      if (token == null || token.isEmpty) {
        return ResponseUtils.badRequest('Token é obrigatório');
      }

      final senhaError = AuthValidators.validatePassword(novaSenha);
      if (senhaError != null) {
        return ResponseUtils.badRequest(senhaError);
      }

      final success = await _repository.resetPassword(token, novaSenha!);

      if (!success) {
        return ResponseUtils.badRequest('Token inválido ou expirado');
      }

      return ResponseUtils.success(
        null,
        message: 'Senha resetada com sucesso',
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao resetar senha: $e');
    }
  }
}

Map<String, dynamic> _parseMultipartForm(String body, String boundary) {
  final map = <String, dynamic>{};
  if (boundary.isEmpty) return map;

  final parts = body.split('--$boundary');
  for (var part in parts) {
    part = part.trim();
    if (part.isEmpty || part == '--') continue;

    final headerBodySplit = part.split('\r\n\r\n');
    if (headerBodySplit.length < 2) continue;

    final headers = headerBodySplit[0];
    final value = headerBodySplit.sublist(1).join('\r\n\r\n').trim();

    final nameMatch = RegExp(r'name="([^"]+)"').firstMatch(headers);
    if (nameMatch != null) {
      final name = nameMatch.group(1)!;
      map[name] = value;
    }
  }

  return map;
}
