class NotificacaoModel {
  final int? id;
  final int? idCriador;
  final int? idAtualizacao;
  final String? titulo;
  final String? conteudo;
  final String? tipoNotificacao;
  final bool? enviarParaTodos;
  final String? status;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;
  final DateTime? dataAgendamento;
  final DateTime? dataExpiracao;
  final String? icone;
  final bool? somNotificacao;
  final bool? vibrar;
  final String? prioridade;

  NotificacaoModel({
    this.id,
    this.idCriador,
    this.idAtualizacao,
    this.titulo,
    this.conteudo,
    this.tipoNotificacao,
    this.enviarParaTodos,
    this.status,
    this.dataCriacao,
    this.dataAtualizacao,
    this.dataAgendamento,
    this.dataExpiracao,
    this.icone,
    this.somNotificacao,
    this.vibrar,
    this.prioridade,
  });

  factory NotificacaoModel.fromMap(Map<String, dynamic> map) {
    return NotificacaoModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idCriador: map['id_criador'] is int
          ? map['id_criador'] as int
          : int.tryParse(map['id_criador']?.toString() ?? ''),
      idAtualizacao: map['id_atualizacao'] is int
          ? map['id_atualizacao'] as int
          : int.tryParse(map['id_atualizacao']?.toString() ?? ''),
      titulo: map['titulo']?.toString(),
      conteudo: map['conteudo']?.toString(),
      tipoNotificacao: map['tipo_notificacao']?.toString(),
      enviarParaTodos: map['enviar_para_todos'] as bool?,
      status: map['status']?.toString(),
      dataCriacao: map['data_criacao'] != null
          ? DateTime.parse(map['data_criacao'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
      dataAgendamento: map['data_agendamento'] != null
          ? DateTime.parse(map['data_agendamento'].toString())
          : null,
      dataExpiracao: map['data_expiracao'] != null
          ? DateTime.parse(map['data_expiracao'].toString())
          : null,
      icone: map['icone']?.toString(),
      somNotificacao: map['som_notificacao'] as bool?,
      vibrar: map['vibrar'] as bool?,
      prioridade: map['prioridade']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_criador': idCriador,
      'id_atualizacao': idAtualizacao,
      'titulo': titulo,
      'conteudo': conteudo,
      'tipo_notificacao': tipoNotificacao,
      'enviar_para_todos': enviarParaTodos,
      'status': status,
      'data_criacao': dataCriacao?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
      'data_agendamento': dataAgendamento?.toIso8601String(),
      'data_expiracao': dataExpiracao?.toIso8601String(),
      'icone': icone,
      'som_notificacao': somNotificacao,
      'vibrar': vibrar,
      'prioridade': prioridade,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCriador': idCriador,
      'idAtualizacao': idAtualizacao,
      'titulo': titulo,
      'conteudo': conteudo,
      'tipoNotificacao': tipoNotificacao,
      'enviarParaTodos': enviarParaTodos,
      'status': status,
      'dataCriacao': dataCriacao?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
      'dataAgendamento': dataAgendamento?.toIso8601String(),
      'dataExpiracao': dataExpiracao?.toIso8601String(),
      'icone': icone,
      'somNotificacao': somNotificacao,
      'vibrar': vibrar,
      'prioridade': prioridade,
    };
  }

  NotificacaoModel copyWith({
    int? id,
    int? idCriador,
    int? idAtualizacao,
    String? titulo,
    String? conteudo,
    String? tipoNotificacao,
    bool? enviarParaTodos,
    String? status,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    DateTime? dataAgendamento,
    DateTime? dataExpiracao,
    String? icone,
    bool? somNotificacao,
    bool? vibrar,
    String? prioridade,
  }) {
    return NotificacaoModel(
      id: id ?? this.id,
      idCriador: idCriador ?? this.idCriador,
      idAtualizacao: idAtualizacao ?? this.idAtualizacao,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      tipoNotificacao: tipoNotificacao ?? this.tipoNotificacao,
      enviarParaTodos: enviarParaTodos ?? this.enviarParaTodos,
      status: status ?? this.status,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      dataAgendamento: dataAgendamento ?? this.dataAgendamento,
      dataExpiracao: dataExpiracao ?? this.dataExpiracao,
      icone: icone ?? this.icone,
      somNotificacao: somNotificacao ?? this.somNotificacao,
      vibrar: vibrar ?? this.vibrar,
      prioridade: prioridade ?? this.prioridade,
    );
  }
}
