class NotificacaoDestinatarioModel {
  final int? id;
  final int? idNotificacao;
  final int? idEgresso;
  final String? canal;
  final String? statusEnvio;
  final String? erroEnvio;
  final DateTime? dataEnvio;

  NotificacaoDestinatarioModel({
    this.id,
    this.idNotificacao,
    this.idEgresso,
    this.canal,
    this.statusEnvio,
    this.erroEnvio,
    this.dataEnvio,
  });

  factory NotificacaoDestinatarioModel.fromMap(Map<String, dynamic> map) {
    return NotificacaoDestinatarioModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idNotificacao: map['id_notificacao'] is int
          ? map['id_notificacao'] as int
          : int.tryParse(map['id_notificacao']?.toString() ?? ''),
      idEgresso: map['id_egresso'] is int
          ? map['id_egresso'] as int
          : int.tryParse(map['id_egresso']?.toString() ?? ''),
      canal: map['canal']?.toString(),
      statusEnvio: map['status_envio']?.toString(),
      erroEnvio: map['erro_envio']?.toString(),
      dataEnvio: map['data_envio'] != null
          ? DateTime.parse(map['data_envio'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_notificacao': idNotificacao,
      'id_egresso': idEgresso,
      'canal': canal,
      'status_envio': statusEnvio,
      'erro_envio': erroEnvio,
      'data_envio': dataEnvio?.toIso8601String(),
    };
  }
}
