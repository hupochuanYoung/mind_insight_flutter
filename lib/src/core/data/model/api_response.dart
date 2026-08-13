/// Generic API response envelope matching the backend's standard format:
/// ```json
/// { "code": 0, "message": "ok", "data": ..., "timestamp": 1786614269968 }
/// ```
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;
  final DateTime? timestamp;

  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.timestamp,
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
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }

  /// Convenience for responses where [data] is null or not needed.
  factory ApiResponse.fromJsonNoData(Map<String, dynamic> json) {
    return ApiResponse<T>(
      code: json['code'] as int? ?? -1,
      message: json['message'] as String? ?? '',
      data: null,
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }

  /// Parse timestamp — supports milliseconds epoch (int) or ISO string.
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
