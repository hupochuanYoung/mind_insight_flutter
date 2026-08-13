class RegisterRequest {
  final String username;
  final String password;
  final String? nickname;

  const RegisterRequest({
    required this.username,
    required this.password,
    this.nickname,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        if (nickname != null) 'nickname': nickname,
      };
}
