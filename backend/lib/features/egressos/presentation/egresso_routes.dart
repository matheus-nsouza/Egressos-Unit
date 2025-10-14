import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/egressos/data/egresso_repository.dart';
import 'package:backend/features/egressos/domain/egresso_model.dart';
import 'package:backend/core/utils/response_utils.dart';

class EgressoRoutes {
  final EgressoRepository _repo = EgressoRepository();

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
      return ResponseUtils.error('Erro ao buscar egressos: $e');
    }
  }

  Future<Response> _search(Request req) async {
    try {
      final params = req.url.queryParameters;
      final nome = params['nome'];
      final email = params['email'];
      final limit =
          params['limit'] != null ? int.tryParse(params['limit']!) : null;
      final offset =
          params['offset'] != null ? int.tryParse(params['offset']!) : null;

      if ((nome == null || nome.isEmpty) && (email == null || email.isEmpty)) {
        final page = await _repo.findAllWithMeta(limit: limit, offset: offset);
        return ResponseUtils.success({
          'data': page.items.map((e) => e.toJson()).toList(),
          'meta': {'total': page.total, 'limit': limit, 'offset': offset}
        });
      }

      final page = await _repo.searchWithMeta(
          nome: nome, email: email, limit: limit, offset: offset);
      return ResponseUtils.success({
        'data': page.items.map((e) => e.toJson()).toList(),
        'meta': {'total': page.total, 'limit': limit, 'offset': offset}
      });
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar egressos: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    try {
      final eid = int.tryParse(id);
      if (eid == null) return ResponseUtils.badRequest('ID inválido');
      final item = await _repo.findById(eid);
      if (item == null) return ResponseUtils.notFound('Egresso não encontrado');
      return ResponseUtils.success(item.toJson());
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar egresso: $e');
    }
  }

  Future<Response> _create(Request req) async {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final nome = data['nomeCompleto'] as String?;
      final email = data['email'] as String?;
      if (nome == null || nome.isEmpty)
        return ResponseUtils.badRequest('nomeCompleto é obrigatório');
      if (email == null || email.isEmpty)
        return ResponseUtils.badRequest('email é obrigatório');

      final model = EgressoModel(
        nomeCompleto: nome,
        email: email,
        telefone: data['telefone'] as String?,
        endereco: data['endereco'] as String?,
        bairro: data['bairro'] as String?,
        cep: data['cep'] as String?,
        fotoUrl: data['fotoUrl'] as String?,
        sexo: data['sexo'] as String?,
        notifApp: data['notifApp'] as bool?,
        notifEmail: data['notifEmail'] as bool?,
        notifSms: data['notifSms'] as bool?,
      );
      final created = await _repo.create(model);
      return Response(201,
          body: jsonEncode({'success': true, 'data': created.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar egresso: $e');
    }
  }

  Future<Response> _update(Request req, String id) async {
    try {
      final eid = int.tryParse(id);
      if (eid == null) return ResponseUtils.badRequest('ID inválido');
      final body = await req.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final existing = await _repo.findById(eid);
      if (existing == null)
        return ResponseUtils.notFound('Egresso não encontrado');

      final updated = existing.copyWith(
        nomeCompleto: data['nomeCompleto'] ?? existing.nomeCompleto,
        email: data['email'] ?? existing.email,
        telefone: data['telefone'] ?? existing.telefone,
        endereco: data['endereco'] ?? existing.endereco,
        bairro: data['bairro'] ?? existing.bairro,
        cep: data['cep'] ?? existing.cep,
        fotoUrl: data['fotoUrl'] ?? existing.fotoUrl,
      );

      final result = await _repo.update(eid, updated);
      return ResponseUtils.success(result?.toJson());
    } catch (e) {
      return ResponseUtils.error('Erro ao atualizar egresso: $e');
    }
  }

  Future<Response> _delete(Request req, String id) async {
    try {
      final eid = int.tryParse(id);
      if (eid == null) return ResponseUtils.badRequest('ID inválido');
      final deleted = await _repo.delete(eid);
      if (!deleted) return ResponseUtils.notFound('Egresso não encontrado');
      return ResponseUtils.success({'message': 'Deletado com sucesso'});
    } catch (e) {
      return ResponseUtils.error('Erro ao deletar egresso: $e');
    }
  }
}
