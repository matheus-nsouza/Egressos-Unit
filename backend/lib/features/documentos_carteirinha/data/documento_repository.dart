import 'package:backend/core/database/connection.dart';
import 'package:backend/features/documentos_carteirinha/domain/documento_model.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/core/utils/pagination_result.dart';

class DocumentoRepository {
  Future<List<DocumentoCarteirinhaModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('SELECT * FROM app.documentos_carteirinha ORDER BY id'));
      return result
          .map((r) => DocumentoCarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<DocumentoCarteirinhaModel>> findAllPaged(
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
      final sql = 'SELECT * FROM app.documentos_carteirinha $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => DocumentoCarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<List<DocumentoCarteirinhaModel>> search(
      {String? tipoDocumento,
      String? nomeOriginal,
      int? limit,
      int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (tipoDocumento != null && tipoDocumento.isNotEmpty) {
        whereClauses.add('tipo_documento ILIKE @tipoDocumento');
        params['tipoDocumento'] = '%$tipoDocumento%';
      }
      if (nomeOriginal != null && nomeOriginal.isNotEmpty) {
        whereClauses.add('nome_original ILIKE @nomeOriginal');
        params['nomeOriginal'] = '%$nomeOriginal%';
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
      final sql = 'SELECT * FROM app.documentos_carteirinha $where';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      return result
          .map((r) => DocumentoCarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<DocumentoCarteirinhaModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.documentos_carteirinha WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return DocumentoCarteirinhaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<DocumentoCarteirinhaModel>> findAllWithMeta(
      {int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final params = <String, dynamic>{};
      var where = '';
      // count
      final countSql =
          'SELECT COUNT(*)::int as total FROM app.documentos_carteirinha $where';
      final countResult =
          await conn.execute(Sql.named(countSql), parameters: params);
      final total = countResult.first.toColumnMap()['total'] as int;

      // items
      var orderSql = 'ORDER BY id';
      if (limit != null) {
        orderSql += ' LIMIT @limit';
        params['limit'] = limit;
      }
      if (offset != null) {
        orderSql += ' OFFSET @offset';
        params['offset'] = offset;
      }
      final sql = 'SELECT * FROM app.documentos_carteirinha $orderSql';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items = result
          .map((r) => DocumentoCarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<PaginationResult<DocumentoCarteirinhaModel>> searchWithMeta(
      {String? tipoDocumento,
      String? nomeOriginal,
      int? limit,
      int? offset}) async {
    final conn = await Database.connect();
    try {
      final whereClauses = <String>[];
      final params = <String, dynamic>{};
      if (tipoDocumento != null && tipoDocumento.isNotEmpty) {
        whereClauses.add('tipo_documento ILIKE @tipoDocumento');
        params['tipoDocumento'] = '%$tipoDocumento%';
      }
      if (nomeOriginal != null && nomeOriginal.isNotEmpty) {
        whereClauses.add('nome_original ILIKE @nomeOriginal');
        params['nomeOriginal'] = '%$nomeOriginal%';
      }
      var where =
          whereClauses.isNotEmpty ? 'WHERE ' + whereClauses.join(' AND ') : '';

      final countSql =
          'SELECT COUNT(*)::int as total FROM app.documentos_carteirinha $where';
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
      final sql = 'SELECT * FROM app.documentos_carteirinha $where $orderSql';
      final result = await conn.execute(Sql.named(sql), parameters: params);
      final items = result
          .map((r) => DocumentoCarteirinhaModel.fromMap(r.toColumnMap()))
          .toList();
      return PaginationResult(items, total);
    } finally {
      await Database.close();
    }
  }

  Future<DocumentoCarteirinhaModel> create(
      DocumentoCarteirinhaModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.documentos_carteirinha (
            id_egresso, id_carteirinha, nome_original, tipo_documento, tamanho_bytes, mime_type, arquivo_url, processado, status, motivo_reprovacao, id_aprovacao
          ) VALUES (
            @idEgresso, @idCarteirinha, @nomeOriginal, @tipoDocumento, @tamanhoBytes, @mimeType, @arquivoUrl, @processado, @status, @motivo, @idAprovacao
          ) RETURNING *
        '''),
        parameters: {
          'idEgresso': model.idEgresso,
          'idCarteirinha': model.idCarteirinha,
          'nomeOriginal': model.nomeOriginal,
          'tipoDocumento': model.tipoDocumento,
          'tamanhoBytes': model.tamanhoBytes,
          'mimeType': model.mimeType,
          'arquivoUrl': model.arquivoUrl,
          'processado': model.processado,
          'status': model.status,
          'motivo': model.motivoReprovacao,
          'idAprovacao': model.idAprovacao,
        },
      );
      return DocumentoCarteirinhaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.documentos_carteirinha WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<DocumentoCarteirinhaModel?> update(
      int id, DocumentoCarteirinhaModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.documentos_carteirinha SET
            nome_original = @nomeOriginal,
            tipo_documento = @tipoDocumento,
            tamanho_bytes = @tamanhoBytes,
            mime_type = @mimeType,
            arquivo_url = @arquivoUrl,
            processado = @processado,
            status = @status,
            motivo_reprovacao = @motivoReprovacao,
            id_aprovacao = @idAprovacao,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'nomeOriginal': model.nomeOriginal,
          'tipoDocumento': model.tipoDocumento,
          'tamanhoBytes': model.tamanhoBytes,
          'mimeType': model.mimeType,
          'arquivoUrl': model.arquivoUrl,
          'processado': model.processado,
          'status': model.status,
          'motivoReprovacao': model.motivoReprovacao,
          'idAprovacao': model.idAprovacao,
          'idAtualizacao': null,
        },
      );
      if (result.isEmpty) return null;
      return DocumentoCarteirinhaModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }
}
