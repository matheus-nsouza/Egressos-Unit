class EgressoModel {
  final int? id;
  final String? nomeCompleto;
  final String? email;
  final String? telefone;
  final String? endereco;
  final String? bairro;
  final String? cep;
  final String? senhaHash;
  final String? sexo;
  final String? fotoUrl;
  final bool? notifApp;
  final bool? notifEmail;
  final bool? notifSms;
  final DateTime? dataCadastro;
  final DateTime? dataAtualizacao;

  EgressoModel({
    this.id,
    this.nomeCompleto,
    this.email,
    this.telefone,
    this.endereco,
    this.bairro,
    this.cep,
    this.senhaHash,
    this.sexo,
    this.fotoUrl,
    this.notifApp,
    this.notifEmail,
    this.notifSms,
    this.dataCadastro,
    this.dataAtualizacao,
  });

  factory EgressoModel.fromMap(Map<String, dynamic> map) {
    return EgressoModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      nomeCompleto: map['nome_completo']?.toString(),
      email: map['email']?.toString(),
      telefone: map['telefone']?.toString(),
      endereco: map['endereco']?.toString(),
      bairro: map['bairro']?.toString(),
      cep: map['cep']?.toString(),
      senhaHash: map['senha_hash']?.toString(),
      sexo: map['sexo']?.toString(),
      fotoUrl: map['foto_url']?.toString(),
      notifApp: map['notif_app'] as bool?,
      notifEmail: map['notif_email'] as bool?,
      notifSms: map['notif_sms'] as bool?,
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
      'nome_completo': nomeCompleto,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'bairro': bairro,
      'cep': cep,
      'senha_hash': senhaHash,
      'sexo': sexo,
      'foto_url': fotoUrl,
      'notif_app': notifApp,
      'notif_email': notifEmail,
      'notif_sms': notifSms,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeCompleto': nomeCompleto,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'bairro': bairro,
      'cep': cep,
      'fotoUrl': fotoUrl,
      'sexo': sexo,
      'notifApp': notifApp,
      'notifEmail': notifEmail,
      'notifSms': notifSms,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
    };
  }

  EgressoModel copyWith({
    int? id,
    String? nomeCompleto,
    String? email,
    String? telefone,
    String? endereco,
    String? bairro,
    String? cep,
    String? senhaHash,
    String? sexo,
    String? fotoUrl,
    bool? notifApp,
    bool? notifEmail,
    bool? notifSms,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
  }) {
    return EgressoModel(
      id: id ?? this.id,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      endereco: endereco ?? this.endereco,
      bairro: bairro ?? this.bairro,
      cep: cep ?? this.cep,
      senhaHash: senhaHash ?? this.senhaHash,
      sexo: sexo ?? this.sexo,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      notifApp: notifApp ?? this.notifApp,
      notifEmail: notifEmail ?? this.notifEmail,
      notifSms: notifSms ?? this.notifSms,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
