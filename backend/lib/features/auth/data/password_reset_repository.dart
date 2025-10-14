import 'package:backend/core/database/connection.dart';
import 'package:backend/features/auth/domain/password_reset_token_model.dart';
import 'package:postgres/postgres.dart';

class PasswordResetRepository {
  Future<PasswordResetTokenModel?> findByTokenHash(String tokenHash) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named(
            'SELECT * FROM app.password_reset_tokens WHERE token_hash = @token'),
        parameters: {'token': tokenHash},
      );
      if (result.isEmpty) return null;
      return PasswordResetTokenModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<PasswordResetTokenModel> create(PasswordResetTokenModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.password_reset_tokens (alvo, alvo_id, token_hash, expira_em, criado_em)
          VALUES (@alvo, @alvoId, @tokenHash, @expiraEm, @criadoEm) RETURNING *
        '''),
        parameters: {
          'alvo': model.alvo,
          'alvoId': model.alvoId,
          'tokenHash': model.tokenHash,
          'expiraEm': model.expiraEm,
          'criadoEm': model.criadoEm,
        },
      );
      return PasswordResetTokenModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }
}
