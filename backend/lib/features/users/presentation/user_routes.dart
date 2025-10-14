import 'dart:convert';
import 'package:backend/features/users/domain/user_model.dart';
import 'package:backend/features/users/data/user_repository.dart';
import 'package:backend/core/utils/response_utils.dart';
import 'package:backend/features/users/domain/validators/user_validation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRoutes {
  final UserRepository _repository = UserRepository();

  Router get router {
    final router = Router();

    router.get('/', _getUsers);

    router.get('/<id>', _getUserById);

    router.post('/', _createUser);

    router.put('/<id>', _updateUser);

    router.patch('/<id>/foto', _updateFoto);

    router.patch('/<id>/senha', _updateSenha);

    router.delete('/<id>', _deleteUser);

    router.get('/search', _searchUsers);

    return router;
  }

  Future<Response> _getUsers(Request req) async {
    try {
      final queryParams = req.url.queryParameters;
      final limit = int.tryParse(queryParams['limit'] ?? '');
      final offset = int.tryParse(queryParams['offset'] ?? '');

      final users = await _repository.findAll(limit: limit, offset: offset);
      final usersJson = users.map((u) => u.toJson()).toList();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': usersJson,
          'total': usersJson.length,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar usuários: $e');
    }
  }

  Future<Response> _getUserById(Request req, String id) async {
    try {
      final userId = int.tryParse(id);
      if (userId == null) {
        return ResponseUtils.badRequest('ID inválido');
      }

      final user = await _repository.findById(userId);
      if (user == null) {
        return ResponseUtils.notFound('Usuário não encontrado');
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': user.toJson(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar usuário: $e');
    }
  }

  Future<Response> _createUser(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final nomeErro =
          UserValidators.validateNomeCompleto(data['nomeCompleto']);
      if (nomeErro != null) {
        return ResponseUtils.badRequest(nomeErro);
      }

      final emailErro = UserValidators.validateEmail(data['email']);
      if (emailErro != null) {
        return ResponseUtils.badRequest(emailErro);
      }

      if (data['senhaHash'] == null || (data['senhaHash'] as String).isEmpty) {
        return ResponseUtils.badRequest('Senha é obrigatória');
      }

      final emailExists = await _repository.emailExists(data['email']);
      if (emailExists) {
        return ResponseUtils.badRequest('Email já cadastrado');
      }

      if (data['fotoUrl'] != null) {
        final fotoErro = UserValidators.validateFotoUrl(data['fotoUrl']);
        if (fotoErro != null) {
          return ResponseUtils.badRequest(fotoErro);
        }
      }

      final idUsuarioCriador = req.context['userId'] as int?;

      final newUser = UserModel(
        nomeCompleto: data['nomeCompleto'],
        email: data['email'],
        senhaHash: data['senhaHash'],
        fotoUrl: data['fotoUrl'],
      );

      final createdUser = await _repository.create(
        newUser,
        idUsuarioCriador: idUsuarioCriador,
      );

      return Response(
        201,
        body: jsonEncode({
          'success': true,
          'message': 'Usuário criado com sucesso',
          'data': createdUser.toJson(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao criar usuário: $e');
    }
  }

  Future<Response> _updateUser(Request req, String id) async {
    try {
      final userId = int.tryParse(id);
      if (userId == null) {
        return ResponseUtils.badRequest('ID inválido');
      }

      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      if (data['nomeCompleto'] != null) {
        final erro = UserValidators.validateNomeCompleto(data['nomeCompleto']);
        if (erro != null) {
          return ResponseUtils.badRequest(erro);
        }
      }

      if (data['email'] != null) {
        final erro = UserValidators.validateEmail(data['email']);
        if (erro != null) {
          return ResponseUtils.badRequest(erro);
        }

        final emailExists = await _repository.emailExists(
          data['email'],
          excludeUserId: userId,
        );
        if (emailExists) {
          return ResponseUtils.badRequest('Email já cadastrado');
        }
      }

      if (data['fotoUrl'] != null) {
        final erro = UserValidators.validateFotoUrl(data['fotoUrl']);
        if (erro != null) {
          return ResponseUtils.badRequest(erro);
        }
      }

      final userAtual = await _repository.findById(userId);
      if (userAtual == null) {
        return ResponseUtils.notFound('Usuário não encontrado');
      }

      final updatedUser = userAtual.copyWith(
        nomeCompleto: data['nomeCompleto'] ?? userAtual.nomeCompleto,
        email: data['email'] ?? userAtual.email,
        fotoUrl: data['fotoUrl'] ?? userAtual.fotoUrl,
      );

      final idUsuarioAtualizacao = req.context['userId'] as int?;

      final user = await _repository.update(
        userId,
        updatedUser,
        idUsuarioAtualizacao: idUsuarioAtualizacao,
      );

      if (user == null) {
        return ResponseUtils.notFound('Usuário não encontrado');
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Usuário atualizado com sucesso',
          'data': user.toJson(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao atualizar usuário: $e');
    }
  }

  Future<Response> _updateFoto(Request req, String id) async {
    try {
      final userId = int.tryParse(id);
      if (userId == null) {
        return ResponseUtils.badRequest('ID inválido');
      }

      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      if (data['fotoUrl'] != null) {
        final erro = UserValidators.validateFotoUrl(data['fotoUrl']);
        if (erro != null) {
          return ResponseUtils.badRequest(erro);
        }
      }

      final user = await _repository.updateFoto(userId, data['fotoUrl']);
      if (user == null) {
        return ResponseUtils.notFound('Usuário não encontrado');
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Foto atualizada com sucesso',
          'data': user.toJson(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao atualizar foto: $e');
    }
  }

  Future<Response> _updateSenha(Request req, String id) async {
    try {
      final userId = int.tryParse(id);
      if (userId == null) {
        return ResponseUtils.badRequest('ID inválido');
      }

      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      if (data['novaSenhaHash'] == null ||
          (data['novaSenhaHash'] as String).isEmpty) {
        return ResponseUtils.badRequest('Nova senha é obrigatória');
      }

      final success = await _repository.updatePassword(
        userId,
        data['novaSenhaHash'],
      );

      if (!success) {
        return ResponseUtils.notFound('Usuário não encontrado');
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Senha atualizada com sucesso',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao atualizar senha: $e');
    }
  }

  Future<Response> _deleteUser(Request req, String id) async {
    try {
      final userId = int.tryParse(id);
      if (userId == null) {
        return ResponseUtils.badRequest('ID inválido');
      }

      final deleted = await _repository.delete(userId);
      if (!deleted) {
        return ResponseUtils.notFound('Usuário não encontrado');
      }

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Usuário deletado com sucesso',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao deletar usuário: $e');
    }
  }

  Future<Response> _searchUsers(Request req) async {
    try {
      final queryParams = req.url.queryParameters;

      final users = await _repository.findWithFilters(
        nomeCompleto: queryParams['nomeCompleto'],
        email: queryParams['email'],
        dataCadastroInicio: queryParams['dataCadastroInicio'] != null
            ? DateTime.parse(queryParams['dataCadastroInicio']!)
            : null,
        dataCadastroFim: queryParams['dataCadastroFim'] != null
            ? DateTime.parse(queryParams['dataCadastroFim']!)
            : null,
      );

      final usersJson = users.map((u) => u.toJson()).toList();

      return Response.ok(
        jsonEncode({
          'success': true,
          'data': usersJson,
          'total': usersJson.length,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar usuários: $e');
    }
  }
}
