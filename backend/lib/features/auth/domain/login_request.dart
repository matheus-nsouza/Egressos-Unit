class LoginRequest {
  final String cpf;
  final String senha;

  LoginRequest({
    required this.cpf,
    required this.senha,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    final rawCpf = (json['cpf'] as String).trim();
    final cleanedCpf = rawCpf.replaceAll(RegExp(r'\D'), '');

    return LoginRequest(
      cpf: cleanedCpf,
      senha: json['senha'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'senha': senha,
    };
  }
}
