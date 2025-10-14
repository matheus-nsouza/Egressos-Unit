import 'dart:convert';
import 'package:backend/features/publicacoes/domain/publicacao_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/publicacoes/data/publicacao_repository.dart';
import 'package:backend/core/utils/response_utils.dart';

class PublicacaoRoutes {
  final PublicacaoRepository _repo = PublicacaoRepository();

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
      return ResponseUtils.error('Erro ao buscar publicações: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(pid);
    if (item == null)
      return ResponseUtils.notFound('Publicação não encontrada');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final idEgresso = data['idEgresso'] is int
          ? data['idEgresso'] as int
          : int.tryParse(data['idEgresso']?.toString() ?? '');
      final titulo = data['titulo'] as String?;
      final conteudo = data['conteudo'] as String?;
      if (idEgresso == null)
        return ResponseUtils.badRequest('idEgresso é obrigatório');
      if (titulo == null || titulo.isEmpty)
        return ResponseUtils.badRequest('titulo é obrigatório');

      final model = PublicacaoModel(
        idEgresso: idEgresso,
        titulo: titulo,
        conteudo: conteudo,
        imagem: data['imagem'] as String?,
        status: data['status'] as String? ?? 'pending',
      );
      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar publicação: $e');
    }
  }

  Future<Response> _update(Request req, String id) async {
    try {
      final pid = int.tryParse(id);
      if (pid == null) return ResponseUtils.badRequest('ID inválido');
      final existing = await _repo.findById(pid);
      if (existing == null)
        return ResponseUtils.notFound('Publicação não encontrada');
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final updated = existing.copyWith(
        titulo: data['titulo'] ?? existing.titulo,
        conteudo: data['conteudo'] ?? existing.conteudo,
        imagem: data['imagem'] ?? existing.imagem,
        status: data['status'] ?? existing.status,
      );

      final result = await _repo.update(pid, updated);
      return ResponseUtils.success(result?.toJson());
    } catch (e) {
      return ResponseUtils.error('Erro ao atualizar publicação: $e');
    }
  }

  Future<Response> _delete(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(pid);
    if (!deleted) return ResponseUtils.notFound('Publicação não encontrada');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }

  Future<Response> _search(Request req) async {
    try {
      final params = req.url.queryParameters;
      final titulo = params['titulo'];
      final conteudo = params['conteudo'];
      final limit =
          params['limit'] != null ? int.tryParse(params['limit']!) : null;
      final offset =
          params['offset'] != null ? int.tryParse(params['offset']!) : null;
      final page = await _repo.searchWithMeta(
          titulo: titulo, conteudo: conteudo, limit: limit, offset: offset);
      return ResponseUtils.success({
        'data': page.items.map((e) => e.toJson()).toList(),
        'meta': {'total': page.total, 'limit': limit, 'offset': offset}
      });
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar publicações: $e');
    }
  }
}
