import 'package:backend/core/database/connection.dart';
import 'package:backend/features/notificacoes/domain/lida_model.dart';
import 'package:postgres/postgres.dart';

class LidaRepository {
  Future<List<NotificacaoLidaModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('SELECT * FROM app.notificacao_lidas ORDER BY id'));
      return result
          .map((r) => NotificacaoLidaModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.notificacao_lidas WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }
}
