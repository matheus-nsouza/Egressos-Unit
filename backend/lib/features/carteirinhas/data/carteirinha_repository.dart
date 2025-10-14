import 'package:backend/core/database/connection.dart';
import 'package:backend/features/carteirinhas/domain/carteirinha_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class CarteirinhaRepository {
  Future<List<CarteirinhaModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn
          .execute(Sql.named('SELECT * FROM app.carteirinhas ORDER BY id'));
      return result
          .map((r) => CarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<CarteirinhaModel>> findAllPaged({int? limit, int? offset}) async {
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
      final sql = 'SELECT * FROM app.carteirinhas $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => CarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<CarteirinhaModel>> search(
      {String? codigoUnico, String? status, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (codigoUnico != null && codigoUnico.isNotEmpty) {
        whereClauses.add('codigo_unico ILIKE @codigoUnico');
        params['codigoUnico'] = '%$codigoUnico%';
      }
      if (status != null && status.isNotEmpty) {
        whereClauses.add('status ILIKE @status');
        params['status'] = '%$status%';
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
      final sql = 'SELECT * FROM app.carteirinhas $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => CarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<CarteirinhaModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.carteirinhas WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return CarteirinhaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<CarteirinhaModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final params = <String, dynamic>{};
      var where = '';
      final countSql =
          'SELECT COUNT(*)::int as total FROM app.carteirinhas $where';
      final countResult =
          await conn.execute(Sql.named(countSql), parameters: params);
      final total = countResult.first.toColumnMap()['total'] as int;

      var orderSql = 'ORDER BY id';
      if (limit != null) {
        orderSql += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        orderSql += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.carteirinhas $orderSql';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => CarteirinhaModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<CarteirinhaModel>> searchWithMeta(
      {String? codigoUnico, String? status, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (codigoUnico != null && codigoUnico.isNotEmpty) {
        whereClauses.add('codigo_unico ILIKE @codigoUnico');
        params['codigoUnico'] = '%$codigoUnico%';
      }
      if (status != null && status.isNotEmpty) {
        whereClauses.add('status ILIKE @status');
        params['status'] = '%$status%';
      }
      var where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';

      final countSql =
          'SELECT COUNT(*)::int as total FROM app.carteirinhas $where';
      final countResult =
          await conn.execute(Sql.named(countSql), parameters: params);
      final total = countResult.first.toColumnMap()['total'] as int;

      var orderSql = ' ORDER BY id DESC';
      if (limit != null) {
        orderSql += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        orderSql += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.carteirinhas $where $orderSql';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => CarteirinhaModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<CarteirinhaModel> create(CarteirinhaModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.carteirinhas (id_egresso, codigo_unico, qr_url, data_emissao, data_validade, status, id_criador)
          VALUES (@idEgresso, @codigoUnico, @qrUrl, @dataEmissao, @dataValidade, @status, @idCriador) RETURNING *
        '''),
        parameters: {
          'idEgresso': model.idEgresso,
          'codigoUnico': model.codigoUnico,
          'qrUrl': model.qrUrl,
          'dataEmissao': model.dataEmissao,
          'dataValidade': model.dataValidade,
          'status': model.status,
          'idCriador': model.idCriador,
        },
      );
      return CarteirinhaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.carteirinhas WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<CarteirinhaModel?> update(int id, CarteirinhaModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.carteirinhas SET
            codigo_unico = @codigoUnico,
            qr_url = @qrUrl,
            data_emissao = @dataEmissao,
            data_validade = @dataValidade,
            status = @status,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'codigoUnico': model.codigoUnico,
          'qrUrl': model.qrUrl,
          'dataEmissao': model.dataEmissao,
          'dataValidade': model.dataValidade,
          'status': model.status,
          'idAtualizacao': model.idAtualizacao,
        },
      );
      if (result.isEmpty) return null;
      return CarteirinhaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }
}
