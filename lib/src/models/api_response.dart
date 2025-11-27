import 'package:freezed_annotation/freezed_annotation.dart';

import 'search_metadata.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// Generic wrapper for API responses.
/// Provides a consistent structure for all API responses with data and metadata.
@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    /// The actual data returned by the API
    required T data,

    /// Metadata about the response (pagination, caching, etc.)
    required SearchMetadata metadata,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}
