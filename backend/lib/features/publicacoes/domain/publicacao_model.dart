class PublicacaoModel {
  final int? id;
  final int? idEgresso;
  final String? titulo;
  final String? conteudo;
  final String? imagem;
  final String? status;
  final DateTime? dataCadastro;
  final DateTime? dataPublicacao;
  final DateTime? dataAprovacao;
  final DateTime? dataAtualizacao;
  final int? idAprovacao;
  final int? idAtualizacao;
  final String? motivoReprovacao;

  PublicacaoModel({
    this.id,
    this.idEgresso,
    this.titulo,
    this.conteudo,
    this.imagem,
    this.status,
    this.dataCadastro,
    this.dataPublicacao,
    this.dataAprovacao,
    this.dataAtualizacao,
    this.idAprovacao,
    this.idAtualizacao,
    this.motivoReprovacao,
  });

  factory PublicacaoModel.fromMap(Map<String, dynamic> map) {
    return PublicacaoModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idEgresso: map['id_egresso'] is int
          ? map['id_egresso'] as int
          : int.tryParse(map['id_egresso']?.toString() ?? ''),
      titulo: map['titulo']?.toString(),
      conteudo: map['conteudo']?.toString(),
      imagem: map['imagem']?.toString(),
      status: map['status']?.toString(),
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
      dataPublicacao: map['data_publicacao'] != null
          ? DateTime.parse(map['data_publicacao'].toString())
          : null,
      dataAprovacao: map['data_aprovacao'] != null
          ? DateTime.parse(map['data_aprovacao'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
      idAprovacao: map['id_aprovacao'] is int
          ? map['id_aprovacao'] as int
          : int.tryParse(map['id_aprovacao']?.toString() ?? ''),
      idAtualizacao: map['id_atualizacao'] is int
          ? map['id_atualizacao'] as int
          : int.tryParse(map['id_atualizacao']?.toString() ?? ''),
      motivoReprovacao: map['motivo_reprovacao']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_egresso': idEgresso,
      'titulo': titulo,
      'conteudo': conteudo,
      'imagem': imagem,
      'status': status,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_publicacao': dataPublicacao?.toIso8601String(),
      'data_aprovacao': dataAprovacao?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
      'id_aprovacao': idAprovacao,
      'id_atualizacao': idAtualizacao,
      'motivo_reprovacao': motivoReprovacao,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idEgresso': idEgresso,
      'titulo': titulo,
      'conteudo': conteudo,
      'imagem': imagem,
      'status': status,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataPublicacao': dataPublicacao?.toIso8601String(),
      'dataAprovacao': dataAprovacao?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
      'idAprovacao': idAprovacao,
      'idAtualizacao': idAtualizacao,
      'motivoReprovacao': motivoReprovacao,
    };
  }

  PublicacaoModel copyWith({
    int? id,
    int? idEgresso,
    String? titulo,
    String? conteudo,
    String? imagem,
    String? status,
    DateTime? dataCadastro,
    DateTime? dataPublicacao,
    DateTime? dataAprovacao,
    DateTime? dataAtualizacao,
    int? idAprovacao,
    int? idAtualizacao,
    String? motivoReprovacao,
  }) {
    return PublicacaoModel(
      id: id ?? this.id,
      idEgresso: idEgresso ?? this.idEgresso,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      imagem: imagem ?? this.imagem,
      status: status ?? this.status,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataPublicacao: dataPublicacao ?? this.dataPublicacao,
      dataAprovacao: dataAprovacao ?? this.dataAprovacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      idAprovacao: idAprovacao ?? this.idAprovacao,
      idAtualizacao: idAtualizacao ?? this.idAtualizacao,
      motivoReprovacao: motivoReprovacao ?? this.motivoReprovacao,
    );
  }
}
