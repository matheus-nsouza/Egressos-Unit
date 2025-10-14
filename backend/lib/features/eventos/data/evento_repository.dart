import 'package:backend/core/database/connection.dart';
import 'package:backend/features/eventos/domain/evento_model.dart';
import 'package:backend/core/utils/pagination_result.dart';
import 'package:postgres/postgres.dart';

class EventoRepository {
  Future<List<EventoModel>> findAll({int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      var order = 'ORDER BY id';
      final params = <String, dynamic>{};
      if (limit != null) {
        order += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        order += ' OFFSET @offset';
        params['offset'] = offset;
      }

      final result = await conn.execute(
          Sql.named('SELECT * FROM app.eventos $order'),
          parameters: params);
      return result.map((r) => EventoModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<EventoModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.eventos WHERE id = @id'),
        parameters: {'id': id},
      );

      if (result.isEmpty) return null;
      return EventoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<EventoModel> create(EventoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.eventos (
            titulo, descricao, imagem_url, tipo, local_nome, link_externo, categoria, requisitos, organizador_nome, status, data_inicio, data_fim, id_criador
          ) VALUES (
            @titulo, @descricao, @imagemUrl, @tipo, @localNome, @linkExterno, @categoria, @requisitos, @organizadorNome, @status, @dataInicio, @dataFim, @idCriador
          ) RETURNING *
        '''),
        parameters: {
          'titulo': model.titulo,
          'descricao': model.descricao,
          'imagemUrl': model.imagemUrl,
          'tipo': model.tipo,
          'localNome': model.localNome,
          'linkExterno': model.linkExterno,
          'categoria': model.categoria,
          'requisitos': model.requisitos,
          'organizadorNome': model.organizadorNome,
          'status': model.status,
          'dataInicio': model.dataInicio,
          'dataFim': model.dataFim,
          'idCriador': model.idCriador,
        },
      );

      return EventoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<EventoModel?> update(int id, EventoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.eventos SET
            titulo = @titulo,
            descricao = @descricao,
            imagem_url = @imagemUrl,
            tipo = @tipo,
            local_nome = @localNome,
            link_externo = @linkExterno,
            categoria = @categoria,
            requisitos = @requisitos,
            organizador_nome = @organizadorNome,
            status = @status,
            data_inicio = @dataInicio,
            data_fim = @dataFim,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'titulo': model.titulo,
          'descricao': model.descricao,
          'imagemUrl': model.imagemUrl,
          'tipo': model.tipo,
          'localNome': model.localNome,
          'linkExterno': model.linkExterno,
          'categoria': model.categoria,
          'requisitos': model.requisitos,
          'organizadorNome': model.organizadorNome,
          'status': model.status,
          'dataInicio': model.dataInicio,
          'dataFim': model.dataFim,
          'idAtualizacao': model.idAtualizacao,
        },
      );

      if (result.isEmpty) return null;
      return EventoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('DELETE FROM app.eventos WHERE id = @id'),
        parameters: {'id': id},
      );
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<List<EventoModel>> search({
    String? categoria,
    String? requisitos,
    String? organizadorNome,
    String? tipo,
  }) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};

      if (categoria != null && categoria.isNotEmpty) {
        whereClauses.add("categoria ILIKE @categoria");
        params['categoria'] = '%$categoria%';
      }
      if (requisitos != null && requisitos.isNotEmpty) {
        whereClauses.add("requisitos ILIKE @requisitos");
        params['requisitos'] = '%$requisitos%';
      }
      if (organizadorNome != null && organizadorNome.isNotEmpty) {
        whereClauses.add("organizador_nome ILIKE @organizadorNome");
        params['organizadorNome'] = '%$organizadorNome%';
      }
      if (tipo != null && tipo.isNotEmpty) {
        whereClauses.add("tipo ILIKE @tipo");
        params['tipo'] = '%$tipo%';
      }

      final where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      final sql = 'SELECT * FROM app.eventos $where ORDER BY id DESC';

      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result.map((r) => EventoModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<EventoModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final countRes = await conn
          .execute(Sql.named('SELECT COUNT(*) as total FROM app.eventos'));
      final total = (countRes.first.toColumnMap()['total'] as int?) ??
          int.parse(countRes.first.toColumnMap()['total'].toString());

      var order = 'ORDER BY id';
      final params = <String, dynamic>{};
      if (limit != null) {
        order += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        order += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final result = await conn.execute(
          Sql.named('SELECT * FROM app.eventos $order'),
          parameters: params);
      final items =
          result.map((r) => EventoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<EventoModel>> searchWithMeta({
    String? categoria,
    String? requisitos,
    String? organizadorNome,
    String? tipo,
    int? limit,
    int? offset,
  }) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};

      if (categoria != null && categoria.isNotEmpty) {
        whereClauses.add("categoria ILIKE @categoria");
        params['categoria'] = '%$categoria%';
      }
      if (requisitos != null && requisitos.isNotEmpty) {
        whereClauses.add("requisitos ILIKE @requisitos");
        params['requisitos'] = '%$requisitos%';
      }
      if (organizadorNome != null && organizadorNome.isNotEmpty) {
        whereClauses.add("organizador_nome ILIKE @organizadorNome");
        params['organizadorNome'] = '%$organizadorNome%';
      }
      if (tipo != null && tipo.isNotEmpty) {
        whereClauses.add("tipo ILIKE @tipo");
        params['tipo'] = '%$tipo%';
      }

      final where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';

      final countSql = 'SELECT COUNT(*) as total FROM app.eventos $where';
      final countRes =
          await conn.execute(Sql.named(countSql), parameters: params);
      final total = (countRes.first.toColumnMap()['total'] as int?) ??
          int.parse(countRes.first.toColumnMap()['total'].toString());

      var order = 'ORDER BY id DESC';
      if (limit != null) {
        order += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        order += ' OFFSET @offset';
        params['offset'] = offset;
      }

      final sql = 'SELECT * FROM app.eventos $where $order';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => EventoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }
}
