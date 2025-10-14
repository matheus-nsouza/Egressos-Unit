class BeneficioResgateModel {
  final int? id;
  final int? idBeneficio;
  final int? idEgresso;
  final String? codigoGerado;
  final String? status;
  final DateTime? dataResgate;
  final DateTime? dataUtilizacao;
  final int? idCriador;
  final int? idAtualizacao;
  final DateTime? dataCadastro;
  final DateTime? dataAtualizacao;

  BeneficioResgateModel({
    this.id,
    this.idBeneficio,
    this.idEgresso,
    this.codigoGerado,
    this.status,
    this.dataResgate,
    this.dataUtilizacao,
    this.idCriador,
    this.idAtualizacao,
    this.dataCadastro,
    this.dataAtualizacao,
  });

  factory BeneficioResgateModel.fromMap(Map<String, dynamic> map) {
    return BeneficioResgateModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idBeneficio: map['id_beneficio'] is int
          ? map['id_beneficio'] as int
          : int.tryParse(map['id_beneficio']?.toString() ?? ''),
      idEgresso: map['id_egresso'] is int
          ? map['id_egresso'] as int
          : int.tryParse(map['id_egresso']?.toString() ?? ''),
      codigoGerado: map['codigo_gerado']?.toString(),
      status: map['status']?.toString(),
      dataResgate: map['data_resgate'] != null
          ? DateTime.parse(map['data_resgate'].toString())
          : null,
      dataUtilizacao: map['data_utilizacao'] != null
          ? DateTime.parse(map['data_utilizacao'].toString())
          : null,
      idCriador: map['id_criador'] is int
          ? map['id_criador'] as int
          : int.tryParse(map['id_criador']?.toString() ?? ''),
      idAtualizacao: map['id_atualizacao'] is int
          ? map['id_atualizacao'] as int
          : int.tryParse(map['id_atualizacao']?.toString() ?? ''),
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_beneficio': idBeneficio,
      'id_egresso': idEgresso,
      'codigo_gerado': codigoGerado,
      'status': status,
      'data_resgate': dataResgate?.toIso8601String(),
      'data_utilizacao': dataUtilizacao?.toIso8601String(),
      'id_criador': idCriador,
      'id_atualizacao': idAtualizacao,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idBeneficio': idBeneficio,
      'idEgresso': idEgresso,
      'codigoGerado': codigoGerado,
      'status': status,
      'dataResgate': dataResgate?.toIso8601String(),
      'dataUtilizacao': dataUtilizacao?.toIso8601String(),
      'idCriador': idCriador,
      'idAtualizacao': idAtualizacao,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  BeneficioResgateModel copyWith({
    int? id,
    int? idBeneficio,
    int? idEgresso,
    String? codigoGerado,
    String? status,
    DateTime? dataResgate,
    DateTime? dataUtilizacao,
    int? idCriador,
    int? idAtualizacao,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
  }) {
    return BeneficioResgateModel(
      id: id ?? this.id,
      idBeneficio: idBeneficio ?? this.idBeneficio,
      idEgresso: idEgresso ?? this.idEgresso,
      codigoGerado: codigoGerado ?? this.codigoGerado,
      status: status ?? this.status,
      dataResgate: dataResgate ?? this.dataResgate,
      dataUtilizacao: dataUtilizacao ?? this.dataUtilizacao,
      idCriador: idCriador ?? this.idCriador,
      idAtualizacao: idAtualizacao ?? this.idAtualizacao,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
