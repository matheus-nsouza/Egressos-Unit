class EventoModel {
  final int? id;
  final String? titulo;
  final String? descricao;
  final String? imagemUrl;
  final String? tipo;
  final String? localNome;
  final String? linkExterno;
  final String? categoria;
  final String? requisitos;
  final String? organizadorNome;
  final String? status;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final int? idCriador;
  final int? idAtualizacao;
  final DateTime? dataCadastro;
  final DateTime? dataAtualizacao;

  EventoModel({
    this.id,
    this.titulo,
    this.descricao,
    this.imagemUrl,
    this.tipo,
    this.localNome,
    this.linkExterno,
    this.categoria,
    this.requisitos,
    this.organizadorNome,
    this.status,
    this.dataInicio,
    this.dataFim,
    this.idCriador,
    this.idAtualizacao,
    this.dataCadastro,
    this.dataAtualizacao,
  });

  factory EventoModel.fromMap(Map<String, dynamic> map) {
    return EventoModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      titulo: map['titulo']?.toString(),
      descricao: map['descricao']?.toString(),
      imagemUrl: map['imagem_url']?.toString(),
      tipo: map['tipo']?.toString(),
      localNome: map['local_nome']?.toString(),
      linkExterno: map['link_externo']?.toString(),
      categoria: map['categoria']?.toString(),
      requisitos: map['requisitos']?.toString(),
      organizadorNome: map['organizador_nome']?.toString(),
      status: map['status']?.toString(),
      dataInicio: map['data_inicio'] != null
          ? DateTime.parse(map['data_inicio'].toString())
          : null,
      dataFim: map['data_fim'] != null
          ? DateTime.parse(map['data_fim'].toString())
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
      'titulo': titulo,
      'descricao': descricao,
      'imagem_url': imagemUrl,
      'tipo': tipo,
      'local_nome': localNome,
      'link_externo': linkExterno,
      'categoria': categoria,
      'requisitos': requisitos,
      'organizador_nome': organizadorNome,
      'status': status,
      'data_inicio': dataInicio?.toIso8601String(),
      'data_fim': dataFim?.toIso8601String(),
      'id_criador': idCriador,
      'id_atualizacao': idAtualizacao,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'imagemUrl': imagemUrl,
      'tipo': tipo,
      'localNome': localNome,
      'linkExterno': linkExterno,
      'categoria': categoria,
      'requisitos': requisitos,
      'organizadorNome': organizadorNome,
      'status': status,
      'dataInicio': dataInicio?.toIso8601String(),
      'dataFim': dataFim?.toIso8601String(),
      'idCriador': idCriador,
      'idAtualizacao': idAtualizacao,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  EventoModel copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? imagemUrl,
    String? tipo,
    String? localNome,
    String? linkExterno,
    String? categoria,
    String? requisitos,
    String? organizadorNome,
    String? status,
    DateTime? dataInicio,
    DateTime? dataFim,
    int? idCriador,
    int? idAtualizacao,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
  }) {
    return EventoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      tipo: tipo ?? this.tipo,
      localNome: localNome ?? this.localNome,
      linkExterno: linkExterno ?? this.linkExterno,
      categoria: categoria ?? this.categoria,
      requisitos: requisitos ?? this.requisitos,
      organizadorNome: organizadorNome ?? this.organizadorNome,
      status: status ?? this.status,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      idCriador: idCriador ?? this.idCriador,
      idAtualizacao: idAtualizacao ?? this.idAtualizacao,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
