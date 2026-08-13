class RegisterParam {
  final String username;
  final String password;
  final String? nickname;

  const RegisterParam({
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
