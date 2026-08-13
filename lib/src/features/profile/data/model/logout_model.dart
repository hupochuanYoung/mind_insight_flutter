class LogoutModel {
  final bool success;

  const LogoutModel({required this.success});

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      success: json['success'] as bool? ?? false,
    );
  }
}
