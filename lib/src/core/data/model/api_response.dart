/// Generic API response envelope matching the backend's standard format:
/// ```json
/// { "code": 0, "message": "ok", "data": ... }
/// ```
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  bool get isSuccess => code == 0;

  /// Factory that parses the outer envelope and delegates [data] parsing
  /// to the provided [fromJsonT] callback.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] as int? ?? -1,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  /// Convenience for responses where [data] is null or not needed.
  factory ApiResponse.fromJsonNoData(Map<String, dynamic> json) {
    return ApiResponse<T>(
      code: json['code'] as int? ?? -1,
      message: json['message'] as String? ?? '',
      data: null,
    );
  }
}
