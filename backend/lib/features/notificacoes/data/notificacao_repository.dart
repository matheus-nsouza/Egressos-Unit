import 'package:backend/core/database/connection.dart';
import 'package:backend/features/notificacoes/domain/notificacao_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class NotificacaoRepository {
  Future<List<NotificacaoModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn
          .execute(Sql.named('SELECT * FROM app.notificacoes ORDER BY id'));
      return result
          .map((r) => NotificacaoModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<NotificacaoModel>> findAllPaged({int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      var where = 'ORDER BY id';
      final params = <String, dynamic>{};
      if (limit != null) {
        where += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        where += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.notificacoes $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => NotificacaoModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<NotificacaoModel>> search(
      {String? titulo,
      String? conteudo,
      String? tipo,
      int? limit,
      int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (titulo != null && titulo.isNotEmpty) {
        whereClauses.add('titulo ILIKE @titulo');
        params['titulo'] = '%$titulo%';
      }
      if (conteudo != null && conteudo.isNotEmpty) {
        whereClauses.add('conteudo ILIKE @conteudo');
        params['conteudo'] = '%$conteudo%';
      }
      if (tipo != null && tipo.isNotEmpty) {
        whereClauses.add('tipo_notificacao ILIKE @tipo');
        params['tipo'] = '%$tipo%';
      }
      var where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      where += ' ORDER BY id DESC';
      if (limit != null) {
        where += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        where += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.notificacoes $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => NotificacaoModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<NotificacaoModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.notificacoes WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return NotificacaoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<NotificacaoModel> create(NotificacaoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.notificacoes (id_criador, id_atualizacao, titulo, conteudo, tipo_notificacao, enviar_para_todos, status, data_agendamento, data_expiracao, icone, som_notificacao, vibrar, prioridade)
          VALUES (@idCriador, @idAtualizacao, @titulo, @conteudo, @tipo, @enviarParaTodos, @status, @dataAgendamento, @dataExpiracao, @icone, @som, @vibrar, @prioridade) RETURNING *
        '''),
        parameters: {
          'idCriador': model.idCriador,
          'idAtualizacao': model.idAtualizacao,
          'titulo': model.titulo,
          'conteudo': model.conteudo,
          'tipo': model.tipoNotificacao,
          'enviarParaTodos': model.enviarParaTodos,
          'status': model.status,
          'dataAgendamento': model.dataAgendamento,
          'dataExpiracao': model.dataExpiracao,
          'icone': model.icone,
          'som': model.somNotificacao,
          'vibrar': model.vibrar,
          'prioridade': model.prioridade,
        },
      );
      return NotificacaoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.notificacoes WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<NotificacaoModel?> update(int id, NotificacaoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.notificacoes SET
            titulo = @titulo,
            conteudo = @conteudo,
            tipo_notificacao = @tipo,
            enviar_para_todos = @enviarParaTodos,
            status = @status,
            data_agendamento = @dataAgendamento,
            data_expiracao = @dataExpiracao,
            icone = @icone,
            som_notificacao = @som,
            vibrar = @vibrar,
            prioridade = @prioridade,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'titulo': model.titulo,
          'conteudo': model.conteudo,
          'tipo': model.tipoNotificacao,
          'enviarParaTodos': model.enviarParaTodos,
          'status': model.status,
          'dataAgendamento': model.dataAgendamento,
          'dataExpiracao': model.dataExpiracao,
          'icone': model.icone,
          'som': model.somNotificacao,
          'vibrar': model.vibrar,
          'prioridade': model.prioridade,
          'idAtualizacao': model.idAtualizacao,
        },
      );
      if (result.isEmpty) return null;
      return NotificacaoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<NotificacaoModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final countRes = await conn
          .execute(Sql.named('SELECT COUNT(*) as total FROM app.notificacoes'));
      final total = (countRes.first.toColumnMap()['total'] as int?) ??
          int.parse(countRes.first.toColumnMap()['total'].toString());
      var where = 'ORDER BY id';
      final params = <String, dynamic>{};
      if (limit != null) {
        where += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        where += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.notificacoes $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => NotificacaoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<NotificacaoModel>> searchWithMeta(
      {String? titulo,
      String? conteudo,
      String? tipo,
      int? limit,
      int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (titulo != null && titulo.isNotEmpty) {
        whereClauses.add('titulo ILIKE @titulo');
        params['titulo'] = '%$titulo%';
      }
      if (conteudo != null && conteudo.isNotEmpty) {
        whereClauses.add('conteudo ILIKE @conteudo');
        params['conteudo'] = '%$conteudo%';
      }
      if (tipo != null && tipo.isNotEmpty) {
        whereClauses.add('tipo_notificacao ILIKE @tipo');
        params['tipo'] = '%$tipo%';
      }
      final where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      final countSql = 'SELECT COUNT(*) as total FROM app.notificacoes $where';
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
      final sql = 'SELECT * FROM app.notificacoes $where $order';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => NotificacaoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }
}
