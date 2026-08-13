class LogoutResponse {
  final bool success;

  const LogoutResponse({required this.success});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] as bool? ?? false,
    );
  }
}
