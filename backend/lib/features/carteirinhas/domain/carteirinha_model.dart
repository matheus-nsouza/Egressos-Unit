class CarteirinhaModel {
  final int? id;
  final int? idEgresso;
  final String? codigoUnico;
  final String? qrUrl;
  final DateTime? dataEmissao;
  final DateTime? dataValidade;
  final DateTime? dataAtualizacao;
  final String? status;
  final int? idCriador;
  final int? idAtualizacao;
  final DateTime? dataCadastro;

  CarteirinhaModel({
    this.id,
    this.idEgresso,
    this.codigoUnico,
    this.qrUrl,
    this.dataEmissao,
    this.dataValidade,
    this.dataAtualizacao,
    this.status,
    this.idCriador,
    this.idAtualizacao,
    this.dataCadastro,
  });

  factory CarteirinhaModel.fromMap(Map<String, dynamic> map) {
    return CarteirinhaModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idEgresso: map['id_egresso'] is int
          ? map['id_egresso'] as int
          : int.tryParse(map['id_egresso']?.toString() ?? ''),
      codigoUnico: map['codigo_unico']?.toString(),
      qrUrl: map['qr_url']?.toString(),
      dataEmissao: map['data_emissao'] != null
          ? DateTime.parse(map['data_emissao'].toString())
          : null,
      dataValidade: map['data_validade'] != null
          ? DateTime.parse(map['data_validade'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
      status: map['status']?.toString(),
      idCriador: map['id_criador'] is int
          ? map['id_criador'] as int
          : int.tryParse(map['id_criador']?.toString() ?? ''),
      idAtualizacao: map['id_atualizacao'] is int
          ? map['id_atualizacao'] as int
          : int.tryParse(map['id_atualizacao']?.toString() ?? ''),
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_egresso': idEgresso,
      'codigo_unico': codigoUnico,
      'qr_url': qrUrl,
      'data_emissao': dataEmissao?.toIso8601String(),
      'data_validade': dataValidade?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
      'status': status,
      'id_criador': idCriador,
      'id_atualizacao': idAtualizacao,
      'data_cadastro': dataCadastro?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idEgresso': idEgresso,
      'codigoUnico': codigoUnico,
      'qrUrl': qrUrl,
      'dataEmissao': dataEmissao?.toIso8601String(),
      'dataValidade': dataValidade?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
      'status': status,
      'idCriador': idCriador,
      'idAtualizacao': idAtualizacao,
      'dataCadastro': dataCadastro?.toIso8601String(),
    };
  }

  CarteirinhaModel copyWith({
    int? id,
    int? idEgresso,
    String? codigoUnico,
    String? qrUrl,
    DateTime? dataEmissao,
    DateTime? dataValidade,
    DateTime? dataAtualizacao,
    String? status,
    int? idCriador,
    int? idAtualizacao,
    DateTime? dataCadastro,
  }) {
    return CarteirinhaModel(
      id: id ?? this.id,
      idEgresso: idEgresso ?? this.idEgresso,
      codigoUnico: codigoUnico ?? this.codigoUnico,
      qrUrl: qrUrl ?? this.qrUrl,
      dataEmissao: dataEmissao ?? this.dataEmissao,
      dataValidade: dataValidade ?? this.dataValidade,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      status: status ?? this.status,
      idCriador: idCriador ?? this.idCriador,
      idAtualizacao: idAtualizacao ?? this.idAtualizacao,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }
}
