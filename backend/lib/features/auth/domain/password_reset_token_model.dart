class PasswordResetTokenModel {
  final int? id;
  final String? alvo;
  final int? alvoId;
  final String? tokenHash;
  final DateTime? expiraEm;
  final DateTime? usadoEm;
  final DateTime? criadoEm;

  PasswordResetTokenModel(
      {this.id,
      this.alvo,
      this.alvoId,
      this.tokenHash,
      this.expiraEm,
      this.usadoEm,
      this.criadoEm});

  factory PasswordResetTokenModel.fromMap(Map<String, dynamic> map) {
    return PasswordResetTokenModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      alvo: map['alvo']?.toString(),
      alvoId: map['alvo_id'] is int
          ? map['alvo_id'] as int
          : int.tryParse(map['alvo_id']?.toString() ?? ''),
      tokenHash: map['token_hash']?.toString(),
      expiraEm: map['expira_em'] != null
          ? DateTime.parse(map['expira_em'].toString())
          : null,
      usadoEm: map['usado_em'] != null
          ? DateTime.parse(map['usado_em'].toString())
          : null,
      criadoEm: map['criado_em'] != null
          ? DateTime.parse(map['criado_em'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alvo': alvo,
      'alvo_id': alvoId,
      'token_hash': tokenHash,
      'expira_em': expiraEm?.toIso8601String(),
      'usado_em': usadoEm?.toIso8601String(),
      'criado_em': criadoEm?.toIso8601String(),
    };
  }
}
