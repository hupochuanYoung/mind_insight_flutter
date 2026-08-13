class LoginResponse {
  final String userId;
  final String accessToken;
  final bool newUser;

  const LoginResponse({
    required this.userId,
    required this.accessToken,
    required this.newUser,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      newUser: json['newUser'] as bool? ?? false,
    );
  }
}
