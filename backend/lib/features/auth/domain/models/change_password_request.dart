class ChangePasswordRequest {
  final String senhaAtual;
  final String novaSenha;

  ChangePasswordRequest({
    required this.senhaAtual,
    required this.novaSenha,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequest(
      senhaAtual: json['senhaAtual'] as String,
      novaSenha: json['novaSenha'] as String,
    );
  }
}
