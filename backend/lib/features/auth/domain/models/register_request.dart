class RegisterRequest {
  final String nomeCompleto;
  final String email;
  final String cpf;
  final String senha;
  final String? fotoUrl;

  RegisterRequest({
    required this.nomeCompleto,
    required this.cpf,
    required this.email,
    required this.senha,
    this.fotoUrl,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    final rawCpf = (json['cpf'] as String).trim();
    final cleanedCpf = rawCpf.replaceAll(RegExp(r'\D'), '');

    return RegisterRequest(
      nomeCompleto: json['nomeCompleto'] as String,
      email: json['email'] as String,
      cpf: cleanedCpf,
      senha: json['senha'] as String,
      fotoUrl: json['fotoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeCompleto': nomeCompleto,
      'email': email,
      'cpf': cpf,
      'senha': senha,
      'fotoUrl': fotoUrl,
    };
  }
}
