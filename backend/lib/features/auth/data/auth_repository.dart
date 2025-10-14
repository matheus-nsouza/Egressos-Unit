import 'package:backend/core/database/connection.dart';
import 'package:backend/features/auth/domain/login_request.dart';
import 'package:backend/features/auth/domain/models/login_response.dart';
import 'package:backend/features/auth/domain/models/register_request.dart';
import 'package:backend/core/utils/hash_helper.dart';
import 'package:backend/core/utils/jwt_helper.dart';
import 'package:postgres/postgres.dart';

class AuthRepository {
  Future<LoginResponse> register(RegisterRequest request) async {
    Connection? conn;

    try {
      conn = await Database.connect();

      final existingByCpf = await conn.execute(
        Sql.named('SELECT id FROM app.usuarios WHERE cpf = @cpf'),
        parameters: {'cpf': request.cpf},
      );

      if (existingByCpf.isNotEmpty) {
        throw Exception('CPF já cadastrado');
      }

      if (request.email.isNotEmpty) {
        final existingByEmail = await conn.execute(
          Sql.named('SELECT id FROM app.usuarios WHERE email = @email'),
          parameters: {'email': request.email},
        );

        if (existingByEmail.isNotEmpty) {
          throw Exception('Email já cadastrado');
        }
      }

      final senhaHash = HashHelper.hashPassword(request.senha);

      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.usuarios (nome_completo, email, cpf, senha_hash, foto_url) 
          VALUES (@nome, @email, @cpf, @senha, @foto) 
          RETURNING id, nome_completo, email, cpf, foto_url, data_cadastro
        '''),
        parameters: {
          'nome': request.nomeCompleto,
          'email': request.email,
          'cpf': request.cpf,
          'senha': senhaHash,
          'foto': request.fotoUrl,
        },
      );

      final userData = result.first.toColumnMap();

      final token = JwtHelper.generateToken(
        userData['id'] as int,
        userData['cpf'] as String,
      );

      return LoginResponse(
        token: token,
        user: {
          'id': userData['id'],
          'nomeCompleto': userData['nome_completo'],
          'cpf': userData['cpf'],
          'fotoUrl': userData['foto_url'],
          'dataCadastro': userData['data_cadastro']?.toString(),
        },
      );
    } finally {
      await Database.close();
    }
  }

  Future<LoginResponse?> login(LoginRequest request) async {
    Connection? conn;

    try {
      conn = await Database.connect();

      final result = await conn.execute(
        Sql.named(
            'SELECT id, nome_completo, cpf, senha_hash, foto_url FROM app.usuarios WHERE cpf = @cpf'),
        parameters: {'cpf': request.cpf},
      );

      if (result.isEmpty) {
        return null;
      }

      final userData = result.first.toColumnMap();

      final senhaHash = HashHelper.hashPassword(request.senha);
      if (senhaHash != userData['senha_hash']) {
        return null;
      }

      final token = JwtHelper.generateToken(
        userData['id'] as int,
        userData['cpf'] as String,
      );

      return LoginResponse(
        token: token,
        user: {
          'id': userData['id'],
          'nomeCompleto': userData['nome_completo'],
          'cpf': userData['cpf'],
          'fotoUrl': userData['foto_url'],
        },
      );
    } finally {
      await Database.close();
    }
  }

  Future<Map<String, dynamic>?> verifyToken(String token) async {
    Connection? conn;

    try {
      final payload = JwtHelper.verifyToken(token);
      final userId = payload['userId'] as int;

      conn = await Database.connect();

      final result = await conn.execute(
        Sql.named(
            'SELECT id, nome_completo, cpf, email, foto_url FROM app.usuarios WHERE id = @id'),
        parameters: {'id': userId},
      );

      if (result.isEmpty) {
        return null;
      }

      final userData = result.first.toColumnMap();

      return {
        'id': userData['id'],
        'nomeCompleto': userData['nome_completo'],
        'cpf': userData['cpf'],
        'fotoUrl': userData['foto_url'],
      };
    } catch (e) {
      return null;
    } finally {
      await conn?.close();
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser(int userId) async {
    Connection? conn;

    try {
      conn = await Database.connect();

      final result = await conn.execute(
        Sql.named(
            'SELECT id, nome_completo, cpf, email, foto_url, data_cadastro FROM app.usuarios WHERE id = @id'),
        parameters: {'id': userId},
      );

      if (result.isEmpty) {
        return null;
      }

      final userData = result.first.toColumnMap();

      return {
        'id': userData['id'],
        'nomeCompleto': userData['nome_completo'],
        'cpf': userData['cpf'],
        'fotoUrl': userData['foto_url'],
        'dataCadastro': userData['data_cadastro']?.toString(),
      };
    } finally {
      await conn?.close();
    }
  }

  Future<bool> changePassword(
      int userId, String senhaAtual, String novaSenha) async {
    Connection? conn;

    try {
      conn = await Database.connect();

      final result = await conn.execute(
        Sql.named('SELECT senha_hash FROM app.usuarios WHERE id = @id'),
        parameters: {'id': userId},
      );

      if (result.isEmpty) {
        return false;
      }

      final senhaHashAtual = result.first.toColumnMap()['senha_hash'] as String;

      if (!HashHelper.verifyPassword(senhaAtual, senhaHashAtual)) {
        throw Exception('Senha atual incorreta');
      }

      final novaSenhaHash = HashHelper.hashPassword(novaSenha);

      await conn.execute(
        Sql.named('''
          UPDATE app.usuarios 
          SET senha_hash = @senha, data_atualizacao = NOW() 
          WHERE id = @id
        '''),
        parameters: {
          'id': userId,
          'senha': novaSenhaHash,
        },
      );

      return true;
    } finally {
      await conn?.close();
    }
  }

  Future<void> logout(String token) async {
    // TODO: Implementar sistema de revogação de tokens
    // Por enquanto, o logout é feito apenas no cliente (remover token)
  }

  Future<String?> refreshToken(String oldToken) async {
    try {
      final payload = JwtHelper.verifyToken(oldToken);
      final userId = payload['userId'] as int;
      final cpf = payload['cpf'] as String;

      final newToken = JwtHelper.generateToken(userId, cpf);

      return newToken;
    } catch (e) {
      return null;
    }
  }

  Future<String?> forgotPassword(String email) async {
    Connection? conn;

    try {
      conn = await Database.connect();

      final result = await conn.execute(
        Sql.named('SELECT id FROM app.usuarios WHERE email = @email'),
        parameters: {'email': email},
      );

      if (result.isEmpty) {
        return null;
      }

      final resetToken = HashHelper.generateToken();

      return resetToken;
    } finally {
      await conn?.close();
    }
  }

  Future<bool> resetPassword(String token, String novaSenha) async {
    Connection? conn;

    try {
      conn = await Database.connect();

      return true;
    } finally {
      await conn?.close();
    }
  }
}
