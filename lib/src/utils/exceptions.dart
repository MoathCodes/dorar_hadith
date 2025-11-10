/// Helper function to handle exceptions with pattern matching example
String getExceptionMessage(DorarException exception) {
  return switch (exception) {
    DorarNetworkException() =>
      'Network error: ${exception.message}. Please check your connection.',
    DorarTimeoutException() =>
      'Request timed out after ${exception.timeout.inSeconds} seconds.',
    DorarNotFoundException() => 'Not found: ${exception.resource}',
    DorarValidationException() =>
      'Validation error: ${exception.message}${exception.field != null ? ' (${exception.field})' : ''}',
    DorarServerException() =>
      'Server error (${exception.statusCode}): ${exception.message}',
    DorarParseException() => 'Failed to parse response: ${exception.message}',
    DorarRateLimitException() =>
      'Rate limit exceeded. ${exception.resetAt != null ? 'Try again after ${exception.resetAt}' : 'Please try again later.'}',
  };
}

/// Base sealed class for all Dorar API exceptions.
/// Using sealed classes provides exhaustive pattern matching.
sealed class DorarException implements Exception {
  /// Error message
  final String message;

  /// Optional error details
  final dynamic details;

  /// HTTP status code (if applicable)
  final int? statusCode;

  const DorarException(this.message, {this.details, this.statusCode});

  @override
  String toString() => 'DorarException: $message';
}

/// Exception thrown when there's a network connectivity issue.
final class DorarNetworkException extends DorarException {
  const DorarNetworkException(super.message, {super.details})
    : super(statusCode: null);

  @override
  String toString() => 'DorarNetworkException: $message';
}

/// Exception thrown when a resource is not found (404).
final class DorarNotFoundException extends DorarException {
  /// The resource that was not found
  final String resource;

  const DorarNotFoundException(
    super.message, {
    required this.resource,
    super.details,
  }) : super(statusCode: 404);

  @override
  String toString() => 'DorarNotFoundException: $message (resource: $resource)';
}

/// Exception thrown when JSON parsing fails.
final class DorarParseException extends DorarException {
  /// The raw data that failed to parse
  final String? rawData;

  /// The type that was expected
  final Type? expectedType;

  const DorarParseException(
    super.message, {
    this.rawData,
    this.expectedType,
    super.details,
  }) : super(statusCode: null);

  @override
  String toString() {
    final parts = ['DorarParseException: $message'];
    if (expectedType != null) parts.add('expected: $expectedType');
    return parts.join(', ');
  }
}

/// Exception thrown when rate limit is exceeded.
final class DorarRateLimitException extends DorarException {
  /// When the rate limit will reset
  final DateTime? resetAt;

  /// Number of requests allowed
  final int? limit;

  const DorarRateLimitException(
    super.message, {
    this.resetAt,
    this.limit,
    super.details,
  }) : super(statusCode: 429);

  @override
  String toString() {
    final parts = ['DorarRateLimitException: $message'];
    if (limit != null) parts.add('limit: $limit');
    if (resetAt != null) {
      parts.add('resets at: ${resetAt!.toIso8601String()}');
    }
    return parts.join(', ');
  }
}

/// Exception thrown when the server returns a 5xx error.
final class DorarServerException extends DorarException {
  const DorarServerException(
    super.message, {
    super.statusCode = 500,
    super.details,
  });

  @override
  String toString() => 'DorarServerException: $message (status: $statusCode)';
}

/// Exception thrown when a request times out.
final class DorarTimeoutException extends DorarException {
  /// The timeout duration that was exceeded
  final Duration timeout;

  const DorarTimeoutException(
    super.message, {
    required this.timeout,
    super.details,
  }) : super(statusCode: 408);

  @override
  String toString() =>
      'DorarTimeoutException: $message (timeout: ${timeout.inSeconds}s)';
}

/// Exception thrown when input validation fails.
final class DorarValidationException extends DorarException {
  /// The field that failed validation
  final String? field;

  /// The validation rule that failed
  final String? rule;

  const DorarValidationException(
    super.message, {
    this.field,
    this.rule,
    super.details,
  }) : super(statusCode: 400);

  @override
  String toString() {
    final parts = ['DorarValidationException: $message'];
    if (field != null) parts.add('field: $field');
    if (rule != null) parts.add('rule: $rule');
    return parts.join(', ');
  }
}
