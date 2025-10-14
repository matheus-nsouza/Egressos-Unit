import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/beneficios_resgates/data/beneficio_resgate_repository.dart';
import 'package:backend/features/beneficios_resgates/domain/beneficio_resgate_model.dart';
import 'package:backend/core/utils/response_utils.dart';

class BeneficioResgateRoutes {
  final BeneficioResgateRepository _repo = BeneficioResgateRepository();

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
      return ResponseUtils.error('Erro ao buscar resgates: $e');
    }
  }

  Future<Response> _search(Request req) async {
    final params = req.url.queryParameters;
    final status = params['status'];
    final codigo = params['codigo'];
    final limit =
        params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final offset =
        params['offset'] != null ? int.tryParse(params['offset']!) : null;
    final result = await _repo.searchWithMeta(
        status: status, codigo: codigo, limit: limit, offset: offset);
    final items = result.items;
    final total = result.total;
    return ResponseUtils.success({
      'data': items.map((e) => e.toJson()).toList(),
      'meta': {'total': total, 'limit': limit, 'offset': offset},
    });
  }

  Future<Response> _getById(Request req, String id) async {
    final rid = int.tryParse(id);
    if (rid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(rid);
    if (item == null) return ResponseUtils.notFound('Resgate não encontrado');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final model = BeneficioResgateModel(
        idBeneficio: data['idBeneficio'] is int
            ? data['idBeneficio'] as int
            : int.tryParse(data['idBeneficio']?.toString() ?? ''),
        idEgresso: data['idEgresso'] is int
            ? data['idEgresso'] as int
            : int.tryParse(data['idEgresso']?.toString() ?? ''),
        codigoGerado: data['codigoGerado'] as String?,
        status: data['status'] as String?,
        dataResgate: data['dataResgate'] != null
            ? DateTime.tryParse(data['dataResgate'].toString())
            : null,
      );
      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar resgate: $e');
    }
  }

  Future<Response> _delete(Request req, String id) async {
    final rid = int.tryParse(id);
    if (rid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(rid);
    if (!deleted) return ResponseUtils.notFound('Resgate não encontrado');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }

  Future<Response> _update(Request req, String id) async {
    final rid = int.tryParse(id);
    if (rid == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(rid);
    if (existing == null)
      return ResponseUtils.notFound('Resgate não encontrado');
    final body = await req.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final updated = existing.copyWith(
      codigoGerado: data['codigoGerado'] ?? existing.codigoGerado,
      status: data['status'] ?? existing.status,
      dataResgate: data['dataResgate'] != null
          ? DateTime.tryParse(data['dataResgate'].toString())
          : existing.dataResgate,
      dataUtilizacao: data['dataUtilizacao'] != null
          ? DateTime.tryParse(data['dataUtilizacao'].toString())
          : existing.dataUtilizacao,
    );

    final result = await _repo.update(rid, updated);
    return ResponseUtils.success(result?.toJson());
  }
}
