import 'package:backend/core/database/connection.dart';
import 'package:backend/features/publicacoes/domain/publicacao_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class PublicacaoRepository {
  Future<List<PublicacaoModel>> findAll({int? limit, int? offset}) async {
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

      final sql = 'SELECT * FROM app.publicacoes $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => PublicacaoModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<PublicacaoModel>> search({
    String? titulo,
    String? conteudo,
    int? limit,
    int? offset,
  }) async {
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

      final sql = 'SELECT * FROM app.publicacoes $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => PublicacaoModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<PublicacaoModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.publicacoes WHERE id = @id'),
        parameters: {'id': id},
      );

      if (result.isEmpty) return null;
      return PublicacaoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PublicacaoModel> create(PublicacaoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.publicacoes (
            id_egresso, titulo, conteudo, imagem, status, data_publicacao, id_aprovacao
          ) VALUES (
            @idEgresso, @titulo, @conteudo, @imagem, @status, @dataPublicacao, @idAprovacao
          ) RETURNING *
        '''),
        parameters: {
          'idEgresso': model.idEgresso,
          'titulo': model.titulo,
          'conteudo': model.conteudo,
          'imagem': model.imagem,
          'status': model.status,
          'dataPublicacao': model.dataPublicacao,
          'idAprovacao': model.idAprovacao,
        },
      );

      return PublicacaoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PublicacaoModel?> update(int id, PublicacaoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.publicacoes SET
            titulo = @titulo,
            conteudo = @conteudo,
            imagem = @imagem,
            status = @status,
            data_publicacao = @dataPublicacao,
            data_aprovacao = @dataAprovacao,
            motivo_reprovacao = @motivoReprovacao,
            data_atualizacao = NOW(),
            id_aprovacao = @idAprovacao,
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'titulo': model.titulo,
          'conteudo': model.conteudo,
          'imagem': model.imagem,
          'status': model.status,
          'dataPublicacao': model.dataPublicacao,
          'dataAprovacao': model.dataAprovacao,
          'motivoReprovacao': model.motivoReprovacao,
          'idAprovacao': model.idAprovacao,
          'idAtualizacao': model.idAtualizacao,
        },
      );

      if (result.isEmpty) return null;
      return PublicacaoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('DELETE FROM app.publicacoes WHERE id = @id'),
        parameters: {'id': id},
      );
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<PublicacaoModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final countRes = await conn
          .execute(Sql.named('SELECT COUNT(*) as total FROM app.publicacoes'));
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
      final sql = 'SELECT * FROM app.publicacoes $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => PublicacaoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<PublicacaoModel>> searchWithMeta(
      {String? titulo, String? conteudo, int? limit, int? offset}) async {
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
      final where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      final countSql = 'SELECT COUNT(*) as total FROM app.publicacoes $where';
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
      final sql = 'SELECT * FROM app.publicacoes $where $order';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => PublicacaoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }
}
