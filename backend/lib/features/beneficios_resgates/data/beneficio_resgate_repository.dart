import 'package:backend/core/database/connection.dart';
import 'package:backend/features/beneficios_resgates/domain/beneficio_resgate_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class BeneficioResgateRepository {
  Future<List<BeneficioResgateModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('SELECT * FROM app.beneficios_resgates ORDER BY id'));
      return result
          .map((r) => BeneficioResgateModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<BeneficioResgateModel>> findAllPaged(
      {int? limit, int? offset}) async {
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
      final sql = 'SELECT * FROM app.beneficios_resgates $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => BeneficioResgateModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<BeneficioResgateModel>> search(
      {String? status, String? codigo, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        whereClauses.add('status ILIKE @status');
        params['status'] = '%$status%';
      }
      if (codigo != null && codigo.isNotEmpty) {
        whereClauses.add('codigo_gerado ILIKE @codigo');
        params['codigo'] = '%$codigo%';
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
      final sql = 'SELECT * FROM app.beneficios_resgates $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => BeneficioResgateModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<BeneficioResgateModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.beneficios_resgates WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return BeneficioResgateModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<BeneficioResgateModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final params = <String, dynamic>{};
      var where = '';
      final countSql =
          'SELECT COUNT(*)::int as total FROM app.beneficios_resgates $where';
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
      final sql = 'SELECT * FROM app.beneficios_resgates $orderSql';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items = result
          .map((r) => BeneficioResgateModel.fromMap(r.toColumnMap()))
          .toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<BeneficioResgateModel>> searchWithMeta(
      {String? status, String? codigo, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        whereClauses.add('status ILIKE @status');
        params['status'] = '%$status%';
      }
      if (codigo != null && codigo.isNotEmpty) {
        whereClauses.add('codigo_gerado ILIKE @codigo');
        params['codigo'] = '%$codigo%';
      }
      var where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';

      final countSql =
          'SELECT COUNT(*)::int as total FROM app.beneficios_resgates $where';
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
      final sql = 'SELECT * FROM app.beneficios_resgates $where $orderSql';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items = result
          .map((r) => BeneficioResgateModel.fromMap(r.toColumnMap()))
          .toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<BeneficioResgateModel> create(BeneficioResgateModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.beneficios_resgates (id_beneficio, id_egresso, codigo_gerado, status, data_resgate, id_criador)
          VALUES (@idBeneficio, @idEgresso, @codigo, @status, @dataResgate, @idCriador) RETURNING *
        '''),
        parameters: {
          'idBeneficio': model.idBeneficio,
          'idEgresso': model.idEgresso,
          'codigo': model.codigoGerado,
          'status': model.status,
          'dataResgate': model.dataResgate,
          'idCriador': model.idCriador,
        },
      );
      return BeneficioResgateModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<BeneficioResgateModel?> update(
      int id, BeneficioResgateModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.beneficios_resgates SET
            codigo_gerado = @codigo,
            status = @status,
            data_resgate = @dataResgate,
            data_utilizacao = @dataUtilizacao,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'codigo': model.codigoGerado,
          'status': model.status,
          'dataResgate': model.dataResgate,
          'dataUtilizacao': model.dataUtilizacao,
          'idAtualizacao': model.idAtualizacao,
        },
      );
      if (result.isEmpty) return null;
      return BeneficioResgateModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.beneficios_resgates WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }
}
