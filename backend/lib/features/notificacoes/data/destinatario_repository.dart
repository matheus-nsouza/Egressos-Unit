import 'package:backend/core/database/connection.dart';
import 'package:backend/features/notificacoes/domain/destinatario_model.dart';
import 'package:backend/features/notificacoes/domain/notificacao_model.dart';
import 'package:postgres/postgres.dart';

class DestinatarioRepository {
  Future<List<NotificacaoDestinatarioModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('SELECT * FROM app.notificacao_destinatarios ORDER BY id'));
      return result
          .map((r) => NotificacaoDestinatarioModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<NotificacaoDestinatarioModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.notificacao_destinatarios WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return NotificacaoDestinatarioModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<NotificacaoDestinatarioModel> create(
      NotificacaoDestinatarioModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.notificacao_destinatarios (id_notificacao, id_egresso, canal, status_envio, erro_envio, data_envio)
          VALUES (@idNotificacao, @idEgresso, @canal, @statusEnvio, @erroEnvio, @dataEnvio) RETURNING *
        '''),
        parameters: {
          'idNotificacao': model.idNotificacao,
          'idEgresso': model.idEgresso,
          'canal': model.canal,
          'statusEnvio': model.statusEnvio,
          'erroEnvio': model.erroEnvio,
          'dataEnvio': model.dataEnvio,
        },
      );
      return NotificacaoDestinatarioModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.notificacao_destinatarios WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }

  Future<List<NotificacaoModel>> findNotificacoesByDestinatario(
      int idEgresso) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(Sql.named('''
        SELECT n.* FROM app.notificacoes n
        JOIN app.notificacao_destinatarios d ON d.id_notificacao = n.id
        WHERE d.id_egresso = @id
        ORDER BY n.id DESC
      '''), parameters: {'id': idEgresso});

      return result
          .map((r) => NotificacaoModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }
}
