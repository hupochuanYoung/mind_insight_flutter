class WechatLoginParam {
  final String code;

  const WechatLoginParam({required this.code});

  Map<String, dynamic> toJson() => {
        'code': code,
      };
}
