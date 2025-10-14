import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/notificacoes/data/notificacao_repository.dart';
import 'package:backend/features/notificacoes/data/destinatario_repository.dart';
import 'package:backend/features/notificacoes/domain/notificacao_model.dart';
import 'package:backend/core/utils/response_utils.dart';

class NotificacaoRoutes {
  final NotificacaoRepository _repo = NotificacaoRepository();
  final DestinatarioRepository _destRepo = DestinatarioRepository();

  Router get router {
    final router = Router();
    router.get('/search', _search);
    router.get('/', _getAll);
    router.get('/destinatario/<id>', _getByDestinatario);
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
      return ResponseUtils.error('Erro ao buscar notificações: $e');
    }
  }

  Future<Response> _search(Request req) async {
    try {
      final params = req.url.queryParameters;
      final titulo = params['titulo'];
      final conteudo = params['conteudo'];
      final tipo = params['tipo'];
      final limit =
          params['limit'] != null ? int.tryParse(params['limit']!) : null;
      final offset =
          params['offset'] != null ? int.tryParse(params['offset']!) : null;
      final page = await _repo.searchWithMeta(
          titulo: titulo,
          conteudo: conteudo,
          tipo: tipo,
          limit: limit,
          offset: offset);
      return ResponseUtils.success({
        'data': page.items.map((e) => e.toJson()).toList(),
        'meta': {'total': page.total, 'limit': limit, 'offset': offset}
      });
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar notificações: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    final nid = int.tryParse(id);
    if (nid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(nid);
    if (item == null)
      return ResponseUtils.notFound('Notificação não encontrada');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final model = NotificacaoModel(
        idCriador: data['idCriador'] is int
            ? data['idCriador'] as int
            : int.tryParse(data['idCriador']?.toString() ?? ''),
        titulo: data['titulo'] as String?,
        conteudo: data['conteudo'] as String?,
        tipoNotificacao: data['tipoNotificacao'] as String?,
        enviarParaTodos: data['enviarParaTodos'] as bool?,
        status: data['status'] as String?,
        dataAgendamento: data['dataAgendamento'] != null
            ? DateTime.tryParse(data['dataAgendamento'].toString())
            : null,
        dataExpiracao: data['dataExpiracao'] != null
            ? DateTime.tryParse(data['dataExpiracao'].toString())
            : null,
        icone: data['icone'] as String?,
        somNotificacao: data['somNotificacao'] as bool?,
        vibrar: data['vibrar'] as bool?,
        prioridade: data['prioridade'] as String?,
      );
      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar notificação: $e');
    }
  }

  Future<Response> _delete(Request req, String id) async {
    final nid = int.tryParse(id);
    if (nid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(nid);
    if (!deleted) return ResponseUtils.notFound('Notificação não encontrada');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }

  Future<Response> _getByDestinatario(Request req, String id) async {
    try {
      final eid = int.tryParse(id);
      if (eid == null) return ResponseUtils.badRequest('ID inválido');
      final items = await _destRepo.findNotificacoesByDestinatario(eid);
      return ResponseUtils.success(items.map((e) => e.toJson()).toList());
    } catch (e) {
      return ResponseUtils.error(
          'Erro ao buscar notificações por destinatário: $e');
    }
  }

  Future<Response> _update(Request req, String id) async {
    final nid = int.tryParse(id);
    if (nid == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(nid);
    if (existing == null)
      return ResponseUtils.notFound('Notificação não encontrada');
    final body = await req.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final updated = existing.copyWith(
      titulo: data['titulo'] ?? existing.titulo,
      conteudo: data['conteudo'] ?? existing.conteudo,
      tipoNotificacao: data['tipoNotificacao'] ?? existing.tipoNotificacao,
      enviarParaTodos: data['enviarParaTodos'] ?? existing.enviarParaTodos,
      status: data['status'] ?? existing.status,
    );

    final result = await _repo.update(nid, updated);
    return ResponseUtils.success(result?.toJson());
  }
}
