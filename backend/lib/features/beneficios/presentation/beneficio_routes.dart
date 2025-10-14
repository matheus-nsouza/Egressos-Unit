import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/features/beneficios/data/beneficio_repository.dart';
import 'package:backend/core/utils/response_utils.dart';

class BeneficioRoutes {
  final BeneficioRepository _repo = BeneficioRepository();

  Router get router {
    final router = Router();
    router.get('/', _getAll);
    router.get('/<id>', _getById);
    router.post('/', _create);
    router.put('/<id>', _update);
    router.delete('/<id>', _delete);
    return router;
  }

  Future<Response> _getAll(Request req) async {
    try {
      final items = await _repo.findAll();
      return ResponseUtils.success(items.map((e) => e.toJson()).toList());
    } catch (e) {
      return ResponseUtils.error('Erro ao buscar benefícios: $e');
    }
  }

  Future<Response> _getById(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final item = await _repo.findById(pid);
    if (item == null) return ResponseUtils.notFound('Benefício não encontrado');
    return ResponseUtils.success(item.toJson());
  }

  Future<Response> _create(Request req) async {
    try {
      final model = await _repo
          .create((await _repo.findById(0)) ?? (throw Exception('dummy')));
      return Response(201,
          body: jsonEncode({'success': true, 'data': model.toJson()}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return ResponseUtils.error('Erro ao criar benefício: $e');
    }
  }

  Future<Response> _update(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final existing = await _repo.findById(pid);
    if (existing == null)
      return ResponseUtils.notFound('Benefício não encontrado');
    final updated = existing;
    final result = await _repo.update(pid, updated);
    return ResponseUtils.success(result?.toJson());
  }

  Future<Response> _delete(Request req, String id) async {
    final pid = int.tryParse(id);
    if (pid == null) return ResponseUtils.badRequest('ID inválido');
    final deleted = await _repo.delete(pid);
    if (!deleted) return ResponseUtils.notFound('Benefício não encontrado');
    return ResponseUtils.success({'message': 'Deletado com sucesso'});
  }
}
