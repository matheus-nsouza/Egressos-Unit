class UserModel {
  final int id;
  final String nomeCompleto;
  final String email;
  final String? fotoUrl;
  final DateTime? dataCadastro;

  UserModel({
    required this.id,
    required this.nomeCompleto,
    required this.email,
    this.fotoUrl,
    this.dataCadastro,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Conversões defensivas: aceita ints como strings e campos nulos
    final idRaw = json['id'];
    final id = idRaw is int ? idRaw : int.tryParse(idRaw?.toString() ?? '') ?? 0;

    final nomeRaw = json['nomeCompleto'] ?? json['nome'] ?? '';
    final nomeCompleto = nomeRaw.toString();

    final emailRaw = json['email'] ?? json['cpf'] ?? '';
    final email = emailRaw.toString();

    final fotoUrlRaw = json['fotoUrl'];
    final fotoUrl = fotoUrlRaw != null ? fotoUrlRaw.toString() : null;

    DateTime? dataCadastro;
    final dataRaw = json['dataCadastro'] ?? json['createdAt'] ?? json['created_at'];
    if (dataRaw != null) {
      try {
        dataCadastro = DateTime.parse(dataRaw.toString());
      } catch (_) {
        dataCadastro = null;
      }
    }

    return UserModel(
      id: id,
      nomeCompleto: nomeCompleto,
      email: email,
      fotoUrl: fotoUrl,
      dataCadastro: dataCadastro,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeCompleto': nomeCompleto,
      'email': email,
      'fotoUrl': fotoUrl,
      'dataCadastro': dataCadastro?.toIso8601String(),
    };
  }

  String get primeiroNome => nomeCompleto.split(' ').first;

  String get iniciais {
    final partes = nomeCompleto.split(' ');
    if (partes.isEmpty) return '';
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }
}
