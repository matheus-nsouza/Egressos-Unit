class ResetPasswordRequest {
  final String token;
  final String novaSenha;

  ResetPasswordRequest({
    required this.token,
    required this.novaSenha,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      token: json['token'] as String,
      novaSenha: json['novaSenha'] as String,
    );
  }
}
