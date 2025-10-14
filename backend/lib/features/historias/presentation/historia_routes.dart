import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/historias/data/historia_repository.dart';
import 'package:backend/features/historias/domain/historia_model.dart';
import 'package:backend/core/utils/response_utils.dart';

class HistoriaRoutes {
  final HistoriaRepository _repo = HistoriaRepository();

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
    try {
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
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar historias: $e');
    }
  }

  Future<Response> _search(Request req) async {
    try {
      final params = req.url.queryParameters;
      final descricao = params['descricao'];
      final limit =
          params['limit'] != null ? int.tryParse(params['limit']!) : null;
      final offset =
          params['offset'] != null ? int.tryParse(params['offset']!) : null;
      final page = await _repo.searchWithMeta(
          descricao: descricao, limit: limit, offset: offset);
      return ResponseUtils.success({
        'data': page.items.map((e) => e.toJson()).toList(),
        'meta': {'total': page.total, 'limit': limit, 'offset': offset}
      });
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar historias: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    final hid = int.tryParse(id);
    if (hid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(hid);
    if (item == null) return ResponseUtils.notFound('Historia não encontrada');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final model = HistoriaModel(
        idEgresso: data['idEgresso'] is int
            ? data['idEgresso'] as int
            : int.tryParse(data['idEgresso']?.toString() ?? ''),
        descricao: data['descricao'] as String?,
        imgAntesUrl: data['imgAntesUrl'] as String?,
        imgDepoisUrl: data['imgDepoisUrl'] as String?,
        status: data['status'] as String?,
      );
      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar historia: $e');
    }
  }

  Future<Response> _delete(Request req, String id) async {
    final hid = int.tryParse(id);
    if (hid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(hid);
    if (!deleted) return ResponseUtils.notFound('Historia não encontrada');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }

  Future<Response> _update(Request req, String id) async {
    final hid = int.tryParse(id);
    if (hid == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(hid);
    if (existing == null)
      return ResponseUtils.notFound('Historia não encontrada');
    final body = await req.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final updated = existing.copyWith(
      descricao: data['descricao'] ?? existing.descricao,
      status: data['status'] ?? existing.status,
      motivoReprovacao: data['motivoReprovacao'] ?? existing.motivoReprovacao,
      imgAntesUrl: data['imgAntesUrl'] ?? existing.imgAntesUrl,
      imgDepoisUrl: data['imgDepoisUrl'] ?? existing.imgDepoisUrl,
    );

    final result = await _repo.update(hid, updated);
    return ResponseUtils.success(result?.toJson());
  }
}
