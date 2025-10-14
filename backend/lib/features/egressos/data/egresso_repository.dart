import 'package:backend/core/database/connection.dart';
import 'package:backend/features/egressos/domain/egresso_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class EgressoRepository {
  Future<List<EgressoModel>> findAll({int? limit, int? offset}) async {
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

      final sql = 'SELECT * FROM app.egressos $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);

      return result.map((r) => EgressoModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<EgressoModel>> search(
      {String? nome, String? email, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};

      if (nome != null && nome.isNotEmpty) {
        whereClauses.add('nome_completo ILIKE @nome');
        params['nome'] = '%$nome%';
      }
      if (email != null && email.isNotEmpty) {
        whereClauses.add('email ILIKE @email');
        params['email'] = '%$email%';
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

      final sql = 'SELECT * FROM app.egressos $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result.map((r) => EgressoModel.fromMap(r.toColumnMap())).toList();
    } finally {
      await Database.close();
    }
  }

  Future<EgressoModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.egressos WHERE id = @id'),
        parameters: {'id': id},
      );

      if (result.isEmpty) return null;
      return EgressoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<EgressoModel> create(EgressoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.egressos (
            nome_completo, email, telefone, endereco, bairro, cep, senha_hash, sexo, foto_url, notif_app, notif_email, notif_sms
          ) VALUES (
            @nome, @email, @telefone, @endereco, @bairro, @cep, @senhaHash, @sexo, @fotoUrl, @notifApp, @notifEmail, @notifSms
          ) RETURNING *
        '''),
        parameters: {
          'nome': model.nomeCompleto,
          'email': model.email,
          'telefone': model.telefone,
          'endereco': model.endereco,
          'bairro': model.bairro,
          'cep': model.cep,
          'senhaHash': model.senhaHash,
          'sexo': model.sexo,
          'fotoUrl': model.fotoUrl,
          'notifApp': model.notifApp,
          'notifEmail': model.notifEmail,
          'notifSms': model.notifSms,
        },
      );

      return EgressoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<EgressoModel?> update(int id, EgressoModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.egressos SET
            nome_completo = @nome,
            email = @email,
            telefone = @telefone,
            endereco = @endereco,
            bairro = @bairro,
            cep = @cep,
            sexo = @sexo,
            foto_url = @fotoUrl,
            notif_app = @notifApp,
            notif_email = @notifEmail,
            notif_sms = @notifSms,
            data_atualizacao = NOW()
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'nome': model.nomeCompleto,
          'email': model.email,
          'telefone': model.telefone,
          'endereco': model.endereco,
          'bairro': model.bairro,
          'cep': model.cep,
          'sexo': model.sexo,
          'fotoUrl': model.fotoUrl,
          'notifApp': model.notifApp,
          'notifEmail': model.notifEmail,
          'notifSms': model.notifSms,
        },
      );

      if (result.isEmpty) return null;
      return EgressoModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('DELETE FROM app.egressos WHERE id = @id'),
        parameters: {'id': id},
      );

      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<EgressoModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final countRes = await conn
          .execute(Sql.named('SELECT COUNT(*) as total FROM app.egressos'));
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
      final sql = 'SELECT * FROM app.egressos $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => EgressoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<EgressoModel>> searchWithMeta(
      {String? nome, String? email, int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (nome != null && nome.isNotEmpty) {
        whereClauses.add('nome_completo ILIKE @nome');
        params['nome'] = '%$nome%';
      }
      if (email != null && email.isNotEmpty) {
        whereClauses.add('email ILIKE @email');
        params['email'] = '%$email%';
      }
      final where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';
      final countSql = 'SELECT COUNT(*) as total FROM app.egressos $where';
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

      final sql = 'SELECT * FROM app.egressos $where $order';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items =
          result.map((r) => EgressoModel.fromMap(r.toColumnMap())).toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }
}
