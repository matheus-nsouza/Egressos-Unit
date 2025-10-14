import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/documentos_carteirinha/data/documento_repository.dart';
import 'package:backend/features/documentos_carteirinha/domain/documento_model.dart';
import 'package:backend/core/utils/response_utils.dart';

class DocumentoRoutes {
  final DocumentoRepository _repo = DocumentoRepository();

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
      return ResponseUtils.error('Erro ao buscar documentos: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    final did = int.tryParse(id);
    if (did == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(did);
    if (item == null) return ResponseUtils.notFound('Documento não encontrado');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final model = DocumentoCarteirinhaModel(
        idEgresso: data['idEgresso'] is int
            ? data['idEgresso'] as int
            : int.tryParse(data['idEgresso']?.toString() ?? ''),
        idCarteirinha: data['idCarteirinha'] is int
            ? data['idCarteirinha'] as int
            : int.tryParse(data['idCarteirinha']?.toString() ?? ''),
        nomeOriginal: data['nomeOriginal'] as String?,
        tipoDocumento: data['tipoDocumento'] as String?,
        tamanhoBytes: data['tamanhoBytes'] is int
            ? data['tamanhoBytes'] as int
            : int.tryParse(data['tamanhoBytes']?.toString() ?? ''),
        mimeType: data['mimeType'] as String?,
        arquivoUrl: data['arquivoUrl'] as String?,
        processado: data['processado'] as bool?,
        status: data['status'] as String?,
      );
      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar documento: $e');
    }
  }

  Future<Response> _delete(Request req, String id) async {
    final did = int.tryParse(id);
    if (did == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(did);
    if (!deleted) return ResponseUtils.notFound('Documento não encontrado');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }

  Future<Response> _update(Request req, String id) async {
    final did = int.tryParse(id);
    if (did == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(did);
    if (existing == null)
      return ResponseUtils.notFound('Documento não encontrado');
    final body = await req.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final updated = existing.copyWith(
      nomeOriginal: data['nomeOriginal'] ?? existing.nomeOriginal,
      tipoDocumento: data['tipoDocumento'] ?? existing.tipoDocumento,
      tamanhoBytes: data['tamanhoBytes'] ?? existing.tamanhoBytes,
      mimeType: data['mimeType'] ?? existing.mimeType,
      arquivoUrl: data['arquivoUrl'] ?? existing.arquivoUrl,
      processado: data['processado'] ?? existing.processado,
      status: data['status'] ?? existing.status,
      motivoReprovacao: data['motivoReprovacao'] ?? existing.motivoReprovacao,
      idAprovacao: data['idAprovacao'] ?? existing.idAprovacao,
    );

    final result = await _repo.update(did, updated);
    return ResponseUtils.success(result?.toJson());
  }

  Future<Response> _search(Request req) async {
    final params = req.url.queryParameters;
    final tipoDocumento = params['tipoDocumento'];
    final nomeOriginal = params['nomeOriginal'];
    final limit =
        params['limit'] != null ? int.tryParse(params['limit']!) : null;
    final offset =
        params['offset'] != null ? int.tryParse(params['offset']!) : null;
    final result = await _repo.searchWithMeta(
        tipoDocumento: tipoDocumento,
        nomeOriginal: nomeOriginal,
        limit: limit,
        offset: offset);
    final items = result.items;
    final total = result.total;
    return ResponseUtils.success({
      'data': items.map((e) => e.toJson()).toList(),
      'meta': {'total': total, 'limit': limit, 'offset': offset},
    });
  }
}
