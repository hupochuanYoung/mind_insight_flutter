class WechatLoginRequest {
  final String code;

  const WechatLoginRequest({required this.code});

  Map<String, dynamic> toJson() => {
        'code': code,
      };
}
