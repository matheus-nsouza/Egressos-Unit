import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/parceiros/data/parceiro_repository.dart';
import 'package:backend/core/utils/response_utils.dart';

class ParceiroRoutes {
  final ParceiroRepository _repo = ParceiroRepository();

  Router get router {
    final router = Router();
    router.get('/search', _search);
    router.get('/', _getAll);
    router.get('/<id>', _getById);
    router.post('/', _create);
    router.put('/<id>', _update);
    router.delete('/<id>', _delete);
    return router;
  }

  Future<Response> _getAll(Request req) async {
    final params = req.url.queryParameters;
    final limit =
        params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final offset =
        params['offset'] != null ? int.tryParse(params['offset']!) : null;
    final page = await _repo.findAllWithMeta(limit: limit, offset: offset);
    return ResponseUtils.success({
      'data': page.items.map((e) => e.toJson()).toList(),
      'meta': {'total': page.total, 'limit': limit, 'offset': offset}
    });
  }

  Future<Response> _search(Request req) async {
    final params = req.url.queryParameters;
    final nome = params['nome'];
    final descricao = params['descricao'];
    final limit =
        params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final offset =
        params['offset'] != null ? int.tryParse(params['offset']!) : null;
    final page = await _repo.searchWithMeta(
        nome: nome, descricao: descricao, limit: limit, offset: offset);
    return ResponseUtils.success({
      'data': page.items.map((e) => e.toJson()).toList(),
      'meta': {'total': page.total, 'limit': limit, 'offset': offset}
    });
  }

  Future<Response> _getById(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(pid);
    if (item == null) return ResponseUtils.notFound('Parceiro não encontrado');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    final model = await _repo
        .create((await _repo.findById(0)) ?? (throw Exception('dummy')));
    return Response(201,
        body: jsonEncode({'success': true, 'data': model.toJson()}),
        headers: {'Content-Type': 'application/json'});
  }

  Future<Response> _update(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(pid);
    if (existing == null)
      return ResponseUtils.notFound('Parceiro não encontrado');
    final updated = existing;
    final result = await _repo.update(pid, updated);
    return ResponseUtils.success(result?.toJson());
  }

  Future<Response> _delete(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(pid);
    if (!deleted) return ResponseUtils.notFound('Parceiro não encontrado');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }
}
