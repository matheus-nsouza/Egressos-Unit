class UserModel {
  final int? id;
  final String nomeCompleto;
  final String email;
  final String? senhaHash;
  final String? fotoUrl;
  final DateTime? dataCadastro;
  final DateTime? dataAtualizacao;
  final int? idUsuarioCriador;
  final int? idUsuarioAtualizacao;

  UserModel({
    this.id,
    required this.nomeCompleto,
    required this.email,
    this.senhaHash,
    this.fotoUrl,
    this.dataCadastro,
    this.dataAtualizacao,
    this.idUsuarioCriador,
    this.idUsuarioAtualizacao,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      nomeCompleto: map['nome_completo']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      senhaHash:
          map['senha_hash'] != null ? map['senha_hash']?.toString() : null,
      fotoUrl: map['foto_url'] != null ? map['foto_url']?.toString() : null,
      dataCadastro: map['data_cadastro'] != null
          ? DateTime.parse(map['data_cadastro'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
      idUsuarioCriador: map['id_usuario_criador'] is int
          ? map['id_usuario_criador'] as int
          : int.tryParse(map['id_usuario_criador']?.toString() ?? ''),
      idUsuarioAtualizacao: map['id_usuario_atualizacao'] is int
          ? map['id_usuario_atualizacao'] as int
          : int.tryParse(map['id_usuario_atualizacao']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_completo': nomeCompleto,
      'email': email,
      'senha_hash': senhaHash,
      'foto_url': fotoUrl,
      'data_cadastro': dataCadastro?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
      'id_usuario_criador': idUsuarioCriador,
      'id_usuario_atualizacao': idUsuarioAtualizacao,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeCompleto': nomeCompleto,
      'email': email,
      'fotoUrl': fotoUrl,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataAtualizacao': dataAtualizacao?.toIso8601String(),
      'idUsuarioCriador': idUsuarioCriador,
      'idUsuarioAtualizacao': idUsuarioAtualizacao,
    };
  }

  UserModel copyWith({
    int? id,
    String? nomeCompleto,
    String? email,
    String? senhaHash,
    String? fotoUrl,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
    int? idUsuarioCriador,
    int? idUsuarioAtualizacao,
  }) {
    return UserModel(
      id: id ?? this.id,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      email: email ?? this.email,
      senhaHash: senhaHash ?? this.senhaHash,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      idUsuarioCriador: idUsuarioCriador ?? this.idUsuarioCriador,
      idUsuarioAtualizacao: idUsuarioAtualizacao ?? this.idUsuarioAtualizacao,
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, nomeCompleto: $nomeCompleto, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
