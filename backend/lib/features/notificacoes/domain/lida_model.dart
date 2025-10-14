class NotificacaoLidaModel {
  final int? id;
  final int? idNotificacao;
  final int? idEgresso;
  final DateTime? dataVisualizacao;

  NotificacaoLidaModel(
      {this.id, this.idNotificacao, this.idEgresso, this.dataVisualizacao});

  factory NotificacaoLidaModel.fromMap(Map<String, dynamic> map) {
    return NotificacaoLidaModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      idNotificacao: map['id_notificacao'] is int
          ? map['id_notificacao'] as int
          : int.tryParse(map['id_notificacao']?.toString() ?? ''),
      idEgresso: map['id_egresso'] is int
          ? map['id_egresso'] as int
          : int.tryParse(map['id_egresso']?.toString() ?? ''),
      dataVisualizacao: map['data_visualizacao'] != null
          ? DateTime.parse(map['data_visualizacao'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_notificacao': idNotificacao,
      'id_egresso': idEgresso,
      'data_visualizacao': dataVisualizacao?.toIso8601String(),
    };
  }
}
