class ProfileModel {
  final int userId;
  final String userNo;
  final String? nickname;
  final String? avatar;
  final int gender;
  final int status;
  final List<String> loginTypes;

  const ProfileModel({
    required this.userId,
    required this.userNo,
    this.nickname,
    this.avatar,
    required this.gender,
    required this.status,
    required this.loginTypes,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userId'] as int? ?? 0,
      userNo: json['userNo'] as String? ?? '',
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      loginTypes:
          (json['loginTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userNo': userNo,
    if (nickname != null) 'nickname': nickname,
    if (avatar != null) 'avatar': avatar,
    'gender': gender,
    'status': status,
    'loginTypes': loginTypes,
  };
}
