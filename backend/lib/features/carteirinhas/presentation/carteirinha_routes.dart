import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/carteirinhas/data/carteirinha_repository.dart';
import 'package:backend/features/carteirinhas/domain/carteirinha_model.dart';
import 'package:backend/core/utils/response_utils.dart';

class CarteirinhaRoutes {
  final CarteirinhaRepository _repo = CarteirinhaRepository();

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
      final result = await _repo.findAllWithMeta(limit: limit, offset: offset);
      final items = result.items;
      final total = result.total;
      return ResponseUtils.success({
        'data': items.map((e) => e.toJson()).toList(),
        'meta': {'total': total, 'limit': limit, 'offset': offset},
      });
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar carteirinhas: $e');
    }
  }

  Future<Response> _search(Request req) async {
    try {
      final params = req.url.queryParameters;
      final codigoUnico = params['codigoUnico'];
      final status = params['status'];
      final limit =
          params['limit'] != null ? int.tryParse(params['limit']!) : null;
      final offset =
          params['offset'] != null ? int.tryParse(params['offset']!) : null;
      final result = await _repo.searchWithMeta(
          codigoUnico: codigoUnico,
          status: status,
          limit: limit,
          offset: offset);
      final items = result.items;
      final total = result.total;
      return ResponseUtils.success({
        'data': items.map((e) => e.toJson()).toList(),
        'meta': {'total': total, 'limit': limit, 'offset': offset},
      });
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar carteirinhas: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    final cid = int.tryParse(id);
    if (cid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(cid);
    if (item == null)
      return ResponseUtils.notFound('Carteirinha não encontrada');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final model = CarteirinhaModel(
        idEgresso: data['idEgresso'] is int
            ? data['idEgresso'] as int
            : int.tryParse(data['idEgresso']?.toString() ?? ''),
        codigoUnico: data['codigoUnico'] as String?,
        qrUrl: data['qrUrl'] as String?,
        dataEmissao: data['dataEmissao'] != null
            ? DateTime.tryParse(data['dataEmissao'].toString())
            : null,
        dataValidade: data['dataValidade'] != null
            ? DateTime.tryParse(data['dataValidade'].toString())
            : null,
        status: data['status'] as String?,
      );
      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar carteirinha: $e');
    }
  }

  Future<Response> _delete(Request req, String id) async {
    final cid = int.tryParse(id);
    if (cid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(cid);
    if (!deleted) return ResponseUtils.notFound('Carteirinha não encontrada');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }

  Future<Response> _update(Request req, String id) async {
    final cid = int.tryParse(id);
    if (cid == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(cid);
    if (existing == null)
      return ResponseUtils.notFound('Carteirinha não encontrada');
    final body = await req.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final updated = existing.copyWith(
      codigoUnico: data['codigoUnico'] ?? existing.codigoUnico,
      qrUrl: data['qrUrl'] ?? existing.qrUrl,
      dataEmissao: data['dataEmissao'] != null
          ? DateTime.tryParse(data['dataEmissao'].toString())
          : existing.dataEmissao,
      dataValidade: data['dataValidade'] != null
          ? DateTime.tryParse(data['dataValidade'].toString())
          : existing.dataValidade,
      status: data['status'] ?? existing.status,
    );

    final result = await _repo.update(cid, updated);
    return ResponseUtils.success(result?.toJson());
  }
}
