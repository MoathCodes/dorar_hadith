import 'search_metadata.dart';

/// Generic wrapper for API responses.
/// Provides a consistent structure for all API responses with data and metadata.
class ApiResponse<T> {
  /// The actual data returned by the API
  final T data;

  /// Metadata about the response (pagination, caching, etc.)
  final SearchMetadata metadata;

  const ApiResponse({required this.data, required this.metadata});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      data: fromJsonT(json['data']),
      metadata: SearchMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson(Object Function(T) toJsonT) {
    return {'data': toJsonT(data), 'metadata': metadata.toJson()};
  }

  @override
  String toString() {
    return 'ApiResponse<$T>(data: $data, metadata: $metadata)';
  }
}
