import 'package:backend/core/database/connection.dart';
import 'package:backend/features/parceiros/domain/parceiro_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class ParceiroRepository {
  Future<List<ParceiroModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn
          .execute(Sql.named('SELECT * FROM app.parceiros ORDER BY id'));
      return result.map((r) => ParceiroModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<ParceiroModel>> findAllPaged({int? limit, int? offset}) async {
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
      final sql = 'SELECT * FROM app.parceiros $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result.map((r) => ParceiroModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<ParceiroModel>> search({String? nome, String? descricao, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (nome != null && nome.isNotEmpty) {
        whereClauses.add('nome ILIKE @nome');
        params['nome'] = '%$nome%';
      }
      if (descricao != null && descricao.isNotEmpty) {
        whereClauses.add('descricao ILIKE @descricao');
        params['descricao'] = '%$descricao%';
      }
      var where = whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      where += ' ORDER BY id DESC';
      if (limit != null) {
        where += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        where += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.parceiros $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result.map((r) => ParceiroModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<ParceiroModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.parceiros WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return ParceiroModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<ParceiroModel> create(ParceiroModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.parceiros (nome, descricao, logo_url, site, id_criador)
          VALUES (@nome, @descricao, @logoUrl, @site, @idCriador) RETURNING *
        '''),
        parameters: {
          'nome': model.nome,
          'descricao': model.descricao,
          'logoUrl': model.logoUrl,
          'site': model.site,
          'idCriador': model.idCriador,
        },
      );
      return ParceiroModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<ParceiroModel?> update(int id, ParceiroModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.parceiros SET
            nome = @nome,
            descricao = @descricao,
            logo_url = @logoUrl,
            site = @site,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'nome': model.nome,
          'descricao': model.descricao,
          'logoUrl': model.logoUrl,
          'site': model.site,
          'idAtualizacao': model.idAtualizacao,
        },
      );
      if (result.isEmpty) return null;
      return ParceiroModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('DELETE FROM app.parceiros WHERE id = @id'),
        parameters: {'id': id},
      );
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<ParceiroModel>> findAllWithMeta({int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final countRes = await conn.execute(Sql.named('SELECT COUNT(*) as total FROM app.parceiros'));
      final total = (countRes.first.toColumnMap()['total'] as int?) ?? int.parse(countRes.first.toColumnMap()['total'].toString());
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
      final sql = 'SELECT * FROM app.parceiros $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items = result.map((r) => ParceiroModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<ParceiroModel>> searchWithMeta({String? nome, String? descricao, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (nome != null && nome.isNotEmpty) {
        whereClauses.add('nome ILIKE @nome');
        params['nome'] = '%$nome%';
      }
      if (descricao != null && descricao.isNotEmpty) {
        whereClauses.add('descricao ILIKE @descricao');
        params['descricao'] = '%$descricao%';
      }
      final where = whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      final countSql = 'SELECT COUNT(*) as total FROM app.parceiros $where';
      final countRes = await conn.execute(Sql.named(countSql), parameters: params);
      final total = (countRes.first.toColumnMap()['total'] as int?) ?? int.parse(countRes.first.toColumnMap()['total'].toString());
      var order = 'ORDER BY id DESC';
      if (limit != null) {
        order += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        order += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.parceiros $where $order';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items = result.map((r) => ParceiroModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }
}
