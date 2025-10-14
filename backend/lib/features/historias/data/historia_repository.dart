import 'package:backend/core/database/connection.dart';
import 'package:backend/features/historias/domain/historia_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class HistoriaRepository {
  Future<List<HistoriaModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn
          .execute(Sql.named('SELECT * FROM app.historias ORDER BY id'));
      return result.map((r) => HistoriaModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<HistoriaModel>> findAllPaged({int? limit, int? offset}) async {
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
      final sql = 'SELECT * FROM app.historias $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result.map((r) => HistoriaModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<HistoriaModel>> search(
      {String? descricao, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (descricao != null && descricao.isNotEmpty) {
        whereClauses.add('descricao ILIKE @descricao');
        params['descricao'] = '%$descricao%';
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
      final sql = 'SELECT * FROM app.historias $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result.map((r) => HistoriaModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<HistoriaModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.historias WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return HistoriaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<HistoriaModel> create(HistoriaModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.historias (id_egresso, img_antes_url, img_depois_url, descricao, status, termo_aceito, termo_versao, termo_data, id_aprovador)
          VALUES (@idEgresso, @imgAntes, @imgDepois, @descricao, @status, @termoAceito, @termoVersao, @termoData, @idAprovador) RETURNING *
        '''),
        parameters: {
          'idEgresso': model.idEgresso,
          'imgAntes': model.imgAntesUrl,
          'imgDepois': model.imgDepoisUrl,
          'descricao': model.descricao,
          'status': model.status,
          'termoAceito': model.termoAceito,
          'termoVersao': model.termoVersao,
          'termoData': model.termoData,
          'idAprovador': model.idAprovador,
        },
      );
      return HistoriaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.historias WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<HistoriaModel?> update(int id, HistoriaModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.historias SET
            img_antes_url = @imgAntes,
            img_depois_url = @imgDepois,
            descricao = @descricao,
            status = @status,
            motivo_reprovacao = @motivoReprovacao,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'imgAntes': model.imgAntesUrl,
          'imgDepois': model.imgDepoisUrl,
          'descricao': model.descricao,
          'status': model.status,
          'motivoReprovacao': model.motivoReprovacao,
          'idAtualizacao': model.idAtualizacao,
        },
      );
      if (result.isEmpty) return null;
      return HistoriaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<HistoriaModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final countRes = await conn
          .execute(Sql.named('SELECT COUNT(*) as total FROM app.historias'));
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
      final sql = 'SELECT * FROM app.historias $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => HistoriaModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<HistoriaModel>> searchWithMeta(
      {String? descricao, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (descricao != null && descricao.isNotEmpty) {
        whereClauses.add('descricao ILIKE @descricao');
        params['descricao'] = '%$descricao%';
      }
      final where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      final countSql = 'SELECT COUNT(*) as total FROM app.historias $where';
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
      final sql = 'SELECT * FROM app.historias $where $order';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => HistoriaModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }
}
