class LoginResponse {
  final String token;
  final Map<String, dynamic> user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user,
    };
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: json['user'] as Map<String, dynamic>,
    );
  }
}
