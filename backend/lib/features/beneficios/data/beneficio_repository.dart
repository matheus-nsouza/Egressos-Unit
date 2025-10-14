import 'package:backend/core/database/connection.dart';
import 'package:backend/features/beneficios/domain/beneficio_model.dart';
import 'package:postgres/postgres.dart';

class BeneficioRepository {
  Future<List<BeneficioModel>> findAll() async {
    final conn = await Database.connect();
    try {
      final result = await conn
          .execute(Sql.named('SELECT * FROM app.beneficios ORDER BY id'));
      return result
          .map((r) => BeneficioModel.fromMap(r.toColumnMap()))
          .toList();
    } finally {
      await Database.close();
    }
  }

  Future<BeneficioModel?> findById(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('SELECT * FROM app.beneficios WHERE id = @id'),
        parameters: {'id': id},
      );
      if (result.isEmpty) return null;
      return BeneficioModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<BeneficioModel> create(BeneficioModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO app.beneficios (id_parceiro, titulo, descricao, tipo, ativo, id_criador, codigo_promocional)
          VALUES (@idParceiro, @titulo, @descricao, @tipo, @ativo, @idCriador, @codigo)
          RETURNING *
        '''),
        parameters: {
          'idParceiro': model.idParceiro,
          'titulo': model.titulo,
          'descricao': model.descricao,
          'tipo': model.tipo,
          'ativo': model.ativo,
          'idCriador': model.idCriador,
          'codigo': model.codigoPromocional,
        },
      );
      return BeneficioModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<BeneficioModel?> update(int id, BeneficioModel model) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
        Sql.named('''
          UPDATE app.beneficios SET
            id_parceiro = @idParceiro,
            titulo = @titulo,
            descricao = @descricao,
            tipo = @tipo,
            ativo = @ativo,
            codigo_promocional = @codigo,
            data_atualizacao = NOW(),
            id_atualizacao = @idAtualizacao
          WHERE id = @id RETURNING *
        '''),
        parameters: {
          'id': id,
          'idParceiro': model.idParceiro,
          'titulo': model.titulo,
          'descricao': model.descricao,
          'tipo': model.tipo,
          'ativo': model.ativo,
          'codigo': model.codigoPromocional,
          'idAtualizacao': model.idAtualizacao,
        },
      );
      if (result.isEmpty) return null;
      return BeneficioModel.fromMap(result.first.toColumnMap());
    } finally {
      await Database.close();
    }
  }

  Future<bool> delete(int id) async {
    final conn = await Database.connect();
    try {
      final result = await conn.execute(
          Sql.named('DELETE FROM app.beneficios WHERE id = @id'),
          parameters: {'id': id});
      return result.affectedRows > 0;
    } finally {
      await Database.close();
    }
  }
}
