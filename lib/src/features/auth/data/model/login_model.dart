class LoginModel {
  final String userId;
  final String accessToken;
  final bool newUser;

  const LoginModel({
    required this.userId,
    required this.accessToken,
    required this.newUser,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      userId: json['userId'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      newUser: json['newUser'] as bool? ?? false,
    );
  }
}
