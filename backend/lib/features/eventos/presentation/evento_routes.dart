import 'dart:convert';
import 'package:backend/features/eventos/domain/evento_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/eventos/data/evento_repository.dart';
import 'package:backend/core/utils/response_utils.dart';

class EventoRoutes {
  final EventoRepository _repo = EventoRepository();

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
      return ResponseUtils.error('Erro ao buscar eventos: $e');
    }
  }

  Future<Response> _search(Request req) async {
    try {
      final params = req.url.queryParameters;
      final categoria = params['categoria'];
      final requisitos = params['requisitos'];
      final organizadorNome = params['organizadorNome'];
      final tipo = params['tipo'];

      if ((categoria == null || categoria.isEmpty) &&
          (requisitos == null || requisitos.isEmpty) &&
          (organizadorNome == null || organizadorNome.isEmpty) &&
          (tipo == null || tipo.isEmpty)) {
        return _getAll(req);
      }

      final limit =
          params['limit'] != null ? int.tryParse(params['limit']!) : null;
      final offset =
          params['offset'] != null ? int.tryParse(params['offset']!) : null;
      final page = await _repo.searchWithMeta(
        categoria: categoria,
        requisitos: requisitos,
        organizadorNome: organizadorNome,
        tipo: tipo,
        limit: limit,
        offset: offset,
      );

      return ResponseUtils.success({
        'data': page.items.map((e) => e.toJson()).toList(),
        'meta': {'total': page.total, 'limit': limit, 'offset': offset}
      });
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar eventos: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    final eid = int.tryParse(id);
    if (eid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(eid);
    if (item == null) return ResponseUtils.notFound('Evento não encontrado');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final titulo = data['titulo'] as String?;
      final dataInicio = data['dataInicio'] != null
          ? DateTime.tryParse(data['dataInicio'].toString())
          : null;
      if (titulo == null || titulo.isEmpty)
        return ResponseUtils.badRequest('titulo é obrigatório');

      final model = EventoModel(
        titulo: titulo,
        descricao: data['descricao'] as String?,
        imagemUrl: data['imagemUrl'] as String?,
        tipo: data['tipo'] as String?,
        localNome: data['localNome'] as String?,
        linkExterno: data['linkExterno'] as String?,
        categoria: data['categoria'] as String?,
        requisitos: data['requisitos'] as String?,
        organizadorNome: data['organizadorNome'] as String?,
        status: data['status'] as String?,
        dataInicio: dataInicio,
        dataFim: data['dataFim'] != null
            ? DateTime.tryParse(data['dataFim'].toString())
            : null,
      );

      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar evento: $e');
    }
  }

  Future<Response> _update(Request req, String id) async {
    final eid = int.tryParse(id);
    if (eid == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(eid);
    if (existing == null)
      return ResponseUtils.notFound('Evento não encontrado');
    final body = await req.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final updated = existing.copyWith(
      titulo: data['titulo'] ?? existing.titulo,
      descricao: data['descricao'] ?? existing.descricao,
      imagemUrl: data['imagemUrl'] ?? existing.imagemUrl,
      tipo: data['tipo'] ?? existing.tipo,
      localNome: data['localNome'] ?? existing.localNome,
      linkExterno: data['linkExterno'] ?? existing.linkExterno,
      categoria: data['categoria'] ?? existing.categoria,
      requisitos: data['requisitos'] ?? existing.requisitos,
      organizadorNome: data['organizadorNome'] ?? existing.organizadorNome,
      status: data['status'] ?? existing.status,
      dataInicio: data['dataInicio'] != null
          ? DateTime.tryParse(data['dataInicio'])
          : existing.dataInicio,
      dataFim: data['dataFim'] != null
          ? DateTime.tryParse(data['dataFim'])
          : existing.dataFim,
    );

    final result = await _repo.update(eid, updated);
    return ResponseUtils.success(result?.toJson());
  }

  Future<Response> _delete(Request req, String id) async {
    final eid = int.tryParse(id);
    if (eid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(eid);
    if (!deleted) return ResponseUtils.notFound('Evento não encontrado');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }
}
