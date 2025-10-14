import 'package:backend/core/database/connection.dart';
import 'package:backend/features/users/domain/user_model.dart';
import 'package:postgres/postgres.dart';

class UserRepository {
  Future<List<UserModel>> findAll({int? limit, int? offset}) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.usuarios ORDER BY id'),
      );

      return result.map((row) => UserModel.fromMap(row.toColumnMap())).toList();
    } finally {
      // TODO: Depois trocar para conn.close() visualizando o ambiente de produção
      await Database.close();
    }
  }

  Future<UserModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.usuarios WHERE id = @id'),
        parameters: {'id': id},
      );

      if (result.isEmpty) return null;
      return UserModel.fromMap(result.first.toColumnMap());
    } catch (e) {
      print('Erro em findById: $e');
      rethrow;
    } finally {
      await Database.close();
    }
  }

  Future<UserModel?> findByEmail(String email) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.usuarios WHERE email = @email'),
        parameters: {'email': email},
      );

      if (result.isEmpty) return null;
      return UserModel.fromMap(result.first.toColumnMap());
    } catch (e) {
      print('Erro em findByEmail: $e');
      rethrow;
    } finally {
      await Database.close();
    }
  }

  Future<List<UserModel>> findWithFilters({
    String? nomeCompleto,
    String? email,
    DateTime? dataCadastroInicio,
    DateTime? dataCadastroFim,
  }) async {
    final conn = await Database.connect();
    try {
      final conditions = <String>[];
      final parameters = <String, dynamic>{};

      if (nomeCompleto != null && nomeCompleto.isNotEmpty) {
        conditions.add('nome_completo ILIKE @nomeCompleto');
        parameters['nomeCompleto'] = '%$nomeCompleto%';
      }

      if (email != null && email.isNotEmpty) {
        conditions.add('email ILIKE @email');
        parameters['email'] = '%$email%';
      }

      if (dataCadastroInicio != null) {
        conditions.add('data_cadastro >= @dataInicio');
        parameters['dataInicio'] = dataCadastroInicio;
      }

      if (dataCadastroFim != null) {
        conditions.add('data_cadastro <= @dataFim');
        parameters['dataFim'] = dataCadastroFim;
      }

      var query = 'SELECT * FROM app.usuarios';
      if (conditions.isNotEmpty) {
        query += ' WHERE ${conditions.join(' AND ')}';
      }
      query += ' ORDER BY id';

      final result = await conn.execute(
        Sql.named(query),
        parameters: parameters,
      );

      return result.map((row) => UserModel.fromMap(row.toColumnMap())).toList();
    } catch (e) {
      print('Erro em findWithFilters: $e');
      rethrow;
    } finally {
      await Database.close();
    }
  }

  Future<UserModel> create(UserModel user, {int? idUsuarioCriador}) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.usuarios (
            nome_completo, 
            email, 
            senha_hash, 
            foto_url,
            id_usuario_criador
          ) 
          VALUES (
            @nomeCompleto, 
            @email, 
            @senhaHash, 
            @fotoUrl,
            @idUsuarioCriador
          ) 
          RETURNING *
        '''),
        parameters: {
          'nomeCompleto': user.nomeCompleto,
          'email': user.email,
          'senhaHash': user.senhaHash,
          'fotoUrl': user.fotoUrl,
          'idUsuarioCriador': idUsuarioCriador,
        },
      );

      return UserModel.fromMap(result.first.toColumnMap());
    } catch (e) {
      print('Erro em create: $e');
      rethrow;
    } finally {
      await Database.close();
    }
  }

  Future<UserModel?> update(int id, UserModel user,
      {int? idUsuarioAtualizacao}) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.usuarios 
          SET 
            nome_completo = @nomeCompleto, 
            email = @email,
            foto_url = @fotoUrl,
            data_atualizacao = NOW(),
            id_usuario_atualizacao = @idUsuarioAtualizacao
          WHERE id = @id 
          RETURNING *
        '''),
        parameters: {
          'id': id,
          'nomeCompleto': user.nomeCompleto,
          'email': user.email,
          'fotoUrl': user.fotoUrl,
          'idUsuarioAtualizacao': idUsuarioAtualizacao,
        },
      );

      if (result.isEmpty) return null;
      return UserModel.fromMap(result.first.toColumnMap());
    } catch (e) {
      print('Erro em update: $e');
      rethrow;
    } finally {
      await Database.close();
    }
  }

  Future<bool> updatePassword(int id, String novaSenhaHash) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.usuarios 
          SET 
            senha_hash = @senhaHash,
            data_atualizacao = NOW()
          WHERE id = @id
        '''),
        parameters: {
          'id': id,
          'senhaHash': novaSenhaHash,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {
      print('Erro em updatePassword: $e');
      rethrow;
    } finally {
      await Database.close();
    }
  }

  Future<UserModel?> updateFoto(int id, String? fotoUrl) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.usuarios 
          SET 
            foto_url = @fotoUrl,
            data_atualizacao = NOW()
          WHERE id = @id 
          RETURNING *
        '''),
        parameters: {
          'id': id,
          'fotoUrl': fotoUrl,
        },
      );

      if (result.isEmpty) return null;
      return UserModel.fromMap(result.first.toColumnMap());
    } catch (e) {
      print('Erro em updateFoto: $e');
      rethrow;
    } finally {
      await conn.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('DELETE FROM app.usuarios WHERE id = @id'),
        parameters: {'id': id},
      );

      return result.affectedRows > 0;
    } catch (e) {
      print('Erro em delete: $e');
      rethrow;
    } finally {
      await conn.close();
    }
  }

  Future<bool> emailExists(String email, {int? excludeUserId}) async {
    final conn = await Database.connect();
    try {
      String query =
          'SELECT COUNT(*) as count FROM app.usuarios WHERE email = @email';
      final parameters = <String, dynamic>{'email': email};

      if (excludeUserId != null) {
        query += ' AND id != @excludeUserId';
        parameters['excludeUserId'] = excludeUserId;
      }

      final result = await conn.execute(
        Sql.named(query),
        parameters: parameters,
      );

      final count = result.first.toColumnMap()['count'] as int;
      return count > 0;
    } catch (e) {
      print('Erro em emailExists: $e');
      rethrow;
    } finally {
      await conn.close();
    }
  }

  Future<int> count() async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT COUNT(*) as count FROM app.usuarios'),
      );

      return result.first.toColumnMap()['count'] as int;
    } catch (e) {
      print('Erro em count: $e');
      rethrow;
    } finally {
      await conn.close();
    }
  }
}
