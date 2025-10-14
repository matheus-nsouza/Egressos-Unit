class ParceiroModel {
  final int? id;
  final String? nome;
  final String? descricao;
  final String? logoUrl;
  final String? site;
  final DateTime? dataCadastro;
  final DateTime? dataAtualizacao;
  final int? idCriador;
  final int? idAtualizacao;

  ParceiroModel({
    this.id,
    this.nome,
    this.descricao,
    this.logoUrl,
    this.site,
    this.dataCadastro,
    this.dataAtualizacao,
    this.idCriador,
    this.idAtualizacao,
  });

  factory ParceiroModel.fromMap(Map<String, dynamic> map) {
    return ParceiroModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      nome: map['nome']?.toString(),
      descricao: map['descricao']?.toString(),
      logoUrl: map['logo_url']?.toString(),
      site: map['site']?.toString(),
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
      idCriador: map['id_criador'] is int
          ? map['id_criador'] as int
          : int.tryParse(map['id_criador']?.toString() ?? ''),
      idAtualizacao: map['id_atualizacao'] is int
          ? map['id_atualizacao'] as int
          : int.tryParse(map['id_atualizacao']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'logo_url': logoUrl,
      'site': site,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
      'id_criador': idCriador,
      'id_atualizacao': idAtualizacao,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'logoUrl': logoUrl,
      'site': site,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
      'idCriador': idCriador,
      'idAtualizacao': idAtualizacao,
    };
  }
}
