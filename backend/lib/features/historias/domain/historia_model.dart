class HistoriaModel {
  final int? id;
  final int? idEgresso;
  final String? imgAntesUrl;
  final String? imgDepoisUrl;
  final String? descricao;
  final String? status;
  final String? motivoReprovacao;
  final bool? termoAceito;
  final String? termoVersao;
  final DateTime? termoData;
  final int? idAprovador;
  final int? idAtualizacao;
  final DateTime? dataCadastro;
  final DateTime? dataAprovacao;
  final DateTime? dataAtualizacao;

  HistoriaModel({
    this.id,
    this.idEgresso,
    this.imgAntesUrl,
    this.imgDepoisUrl,
    this.descricao,
    this.status,
    this.motivoReprovacao,
    this.termoAceito,
    this.termoVersao,
    this.termoData,
    this.idAprovador,
    this.idAtualizacao,
    this.dataCadastro,
    this.dataAprovacao,
    this.dataAtualizacao,
  });

  factory HistoriaModel.fromMap(Map<String, dynamic> map) {
    return HistoriaModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idEgresso: map['id_egresso'] is int
          ? map['id_egresso'] as int
          : int.tryParse(map['id_egresso']?.toString() ?? ''),
      imgAntesUrl: map['img_antes_url']?.toString(),
      imgDepoisUrl: map['img_depois_url']?.toString(),
      descricao: map['descricao']?.toString(),
      status: map['status']?.toString(),
      motivoReprovacao: map['motivo_reprovacao']?.toString(),
      termoAceito: map['termo_aceito'] as bool?,
      termoVersao: map['termo_versao']?.toString(),
      termoData: map['termo_data'] != null
          ? DateTime.parse(map['termo_data'].toString())
          : null,
      idAprovador: map['id_aprovador'] is int
          ? map['id_aprovador'] as int
          : int.tryParse(map['id_aprovador']?.toString() ?? ''),
      idAtualizacao: map['id_atualizacao'] is int
          ? map['id_atualizacao'] as int
          : int.tryParse(map['id_atualizacao']?.toString() ?? ''),
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
      dataAprovacao: map['data_aprovacao'] != null
          ? DateTime.parse(map['data_aprovacao'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_egresso': idEgresso,
      'img_antes_url': imgAntesUrl,
      'img_depois_url': imgDepoisUrl,
      'descricao': descricao,
      'status': status,
      'motivo_reprovacao': motivoReprovacao,
      'termo_aceito': termoAceito,
      'termo_versao': termoVersao,
      'termo_data': termoData?.toIso8601String(),
      'id_aprovador': idAprovador,
      'id_atualizacao': idAtualizacao,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_aprovacao': dataAprovacao?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idEgresso': idEgresso,
      'imgAntesUrl': imgAntesUrl,
      'imgDepoisUrl': imgDepoisUrl,
      'descricao': descricao,
      'status': status,
      'motivoReprovacao': motivoReprovacao,
      'termoAceito': termoAceito,
      'termoVersao': termoVersao,
      'termoData': termoData?.toIso8601String(),
      'idAprovador': idAprovador,
      'idAtualizacao': idAtualizacao,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAprovacao': dataAprovacao?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  HistoriaModel copyWith({
    int? id,
    int? idEgresso,
    String? imgAntesUrl,
    String? imgDepoisUrl,
    String? descricao,
    String? status,
    String? motivoReprovacao,
    bool? termoAceito,
    String? termoVersao,
    DateTime? termoData,
    int? idAprovador,
    int? idAtualizacao,
    DateTime? dataCadastro,
    DateTime? dataAprovacao,
    DateTime? dataAtualizacao,
  }) {
    return HistoriaModel(
      id: id ?? this.id,
      idEgresso: idEgresso ?? this.idEgresso,
      imgAntesUrl: imgAntesUrl ?? this.imgAntesUrl,
      imgDepoisUrl: imgDepoisUrl ?? this.imgDepoisUrl,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      motivoReprovacao: motivoReprovacao ?? this.motivoReprovacao,
      termoAceito: termoAceito ?? this.termoAceito,
      termoVersao: termoVersao ?? this.termoVersao,
      termoData: termoData ?? this.termoData,
      idAprovador: idAprovador ?? this.idAprovador,
      idAtualizacao: idAtualizacao ?? this.idAtualizacao,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAprovacao: dataAprovacao ?? this.dataAprovacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
