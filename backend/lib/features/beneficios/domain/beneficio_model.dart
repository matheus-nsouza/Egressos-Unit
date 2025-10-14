class BeneficioModel {
  final int? id;
  final int? idParceiro;
  final String? titulo;
  final String? descricao;
  final String? tipo;
  final DateTime? dataCadastro;
  final DateTime? dataAtualizacao;
  final bool? ativo;
  final int? idCriador;
  final int? idAtualizacao;
  final String? codigoPromocional;

  BeneficioModel({
    this.id,
    this.idParceiro,
    this.titulo,
    this.descricao,
    this.tipo,
    this.dataCadastro,
    this.dataAtualizacao,
    this.ativo,
    this.idCriador,
    this.idAtualizacao,
    this.codigoPromocional,
  });

  factory BeneficioModel.fromMap(Map<String, dynamic> map) {
    return BeneficioModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idParceiro: map['id_parceiro'] is int
          ? map['id_parceiro'] as int
          : int.tryParse(map['id_parceiro']?.toString() ?? ''),
      titulo: map['titulo']?.toString(),
      descricao: map['descricao']?.toString(),
      tipo: map['tipo']?.toString(),
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
      ativo: map['ativo'] as bool?,
      idCriador: map['id_criador'] is int
          ? map['id_criador'] as int
          : int.tryParse(map['id_criador']?.toString() ?? ''),
      idAtualizacao: map['id_atualizacao'] is int
          ? map['id_atualizacao'] as int
          : int.tryParse(map['id_atualizacao']?.toString() ?? ''),
      codigoPromocional: map['codigo_promocional']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_parceiro': idParceiro,
      'titulo': titulo,
      'descricao': descricao,
      'tipo': tipo,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
      'ativo': ativo,
      'id_criador': idCriador,
      'id_atualizacao': idAtualizacao,
      'codigo_promocional': codigoPromocional,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idParceiro': idParceiro,
      'titulo': titulo,
      'descricao': descricao,
      'tipo': tipo,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
      'ativo': ativo,
      'idCriador': idCriador,
      'idAtualizacao': idAtualizacao,
      'codigoPromocional': codigoPromocional,
    };
  }
}
