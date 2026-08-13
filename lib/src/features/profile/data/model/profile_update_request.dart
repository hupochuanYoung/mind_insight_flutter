class ProfileUpdateRequest {
  final String? nickname;
  final String? avatar;
  final int? gender;

  const ProfileUpdateRequest({
    this.nickname,
    this.avatar,
    this.gender,
  });

  Map<String, dynamic> toJson() => {
        if (nickname != null) 'nickname': nickname,
        if (avatar != null) 'avatar': avatar,
        if (gender != null) 'gender': gender,
      };
}
