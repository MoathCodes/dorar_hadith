import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/exceptions.dart';
import '../utils/validators.dart';

/// HTTP client wrapper for making requests to Dorar.net API.
///
/// Features automatic timeout handling, retry logic with exponential backoff,
/// and typed error handling.
class DorarHttpClient {
  /// Browser-like headers matching dorar-hadith-api `fetchWithTimeout`
  /// (avoids Dorar 403 responses).
  static const Map<String, String> defaultHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Safari/537.36',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'ar,en;q=0.9',
    'Referer': 'https://dorar.net/',
    'Origin': 'https://dorar.net',
    'Connection': 'keep-alive',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    'Cache-Control': 'no-cache',
    'Pragma': 'no-cache',
  };

  /// HTTP client instance
  final http.Client _client;

  /// Default timeout for requests (15 seconds, matching Node.js API)
  final Duration timeout;

  /// Maximum number of retry attempts
  final int maxRetries;

  /// Base delay between retries (exponential backoff)
  final Duration retryDelay;

  /// Whether to enable debug logging
  final bool enableLogging;

  /// Create a new HTTP client
  ///
  /// - [client] - Optional http.Client instance (useful for testing)
  /// - [timeout] - Request timeout duration (default: 15 seconds)
  /// - [maxRetries] - Maximum retry attempts (default: 3)
  /// - [retryDelay] - Base delay between retries (default: 1 second)
  /// - [enableLogging] - Enable request/response logging (default: false)
  DorarHttpClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.enableLogging = false,
  }) : _client = client ?? http.Client() {
    if (maxRetries < 1) {
      throw ArgumentError.value(maxRetries, 'maxRetries', 'Must be positive');
    }
    // Validate timeout
    Validators.validateTimeout(timeout);
  }

  /// Close the HTTP client and free resources
  void dispose() {
    _client.close();
  }

  /// Merge [defaultHeaders] with optional caller [headers] (caller wins).
  static Map<String, String> mergeHeaders([Map<String, String>? headers]) {
    return {...defaultHeaders, ...?headers};
  }

  /// Make a GET request
  ///
  /// Returns the response body as a string.
  /// Throws [DorarException] on error.
  Future<DorarHttpResponse> getResponse(
    String url, {
    Map<String, String>? headers,
    Duration? customTimeout,
  }) async {
    Validators.validateUrl(url);

    final effectiveTimeout = customTimeout ?? timeout;
    final effectiveHeaders = mergeHeaders(headers);
    var attempt = 0;

    while (attempt < maxRetries) {
      attempt++;

      try {
        if (enableLogging) {
          print('[DorarHttpClient] GET $url (attempt $attempt/$maxRetries)');
        }

        final response = await _client
            .get(Uri.parse(url), headers: effectiveHeaders)
            .timeout(effectiveTimeout);

        if (enableLogging) {
          print('[DorarHttpClient] Response ${response.statusCode} for $url');
        }

        // Handle response based on status code
        if (response.statusCode == 200) {
          final contentType = response.headers['content-type'];
          final encoding =
              contentType?.toLowerCase().contains('charset=iso-8859-1') == true
              ? latin1
              : utf8;
          final body = encoding.decode(response.bodyBytes);
          return DorarHttpResponse(
            body: body,
            statusCode: response.statusCode,
            contentType: contentType,
            encoding: encoding.name,
            finalUri: response.request?.url,
            fetchedAt: DateTime.now().toUtc(),
          );
        } else if (response.statusCode == 404) {
          throw DorarNotFoundException('Resource not found', resource: url);
        } else if (response.statusCode == 429) {
          // Rate limit - extract reset time if available
          final retryAfter = response.headers['retry-after'];
          final resetAt = retryAfter != null
              ? DateTime.now().add(Duration(seconds: int.parse(retryAfter)))
              : DateTime.now().add(const Duration(hours: 1));

          throw DorarRateLimitException('Too many requests', resetAt: resetAt);
        } else if (response.statusCode >= 500) {
          throw DorarServerException(
            'Server error: ${response.reasonPhrase}',
            statusCode: response.statusCode,
          );
        } else {
          throw DorarNetworkException(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          );
        }
      } on TimeoutException {
        if (enableLogging) {
          print('[DorarHttpClient] Timeout on attempt $attempt/$maxRetries');
        }

        // If this was the last attempt, throw timeout exception
        if (attempt >= maxRetries) {
          throw DorarTimeoutException(
            'Request timed out after ${effectiveTimeout.inSeconds} seconds',
            timeout: effectiveTimeout,
          );
        }

        // Wait before retrying with exponential backoff
        await _waitBeforeRetry(attempt);
      } on DorarException {
        // Re-throw our custom exceptions
        rethrow;
      } on http.ClientException catch (e) {
        if (enableLogging) {
          print('[DorarHttpClient] Network error: $e');
        }

        // If this was the last attempt, throw network exception
        if (attempt >= maxRetries) {
          throw DorarNetworkException('Network error: ${e.message}');
        }

        // Wait before retrying
        await _waitBeforeRetry(attempt);
      } catch (e) {
        if (enableLogging) {
          print('[DorarHttpClient] Unexpected error: $e');
        }

        throw DorarNetworkException('Unexpected error: $e');
      }
    }

    // This should never be reached due to the throws above
    throw DorarNetworkException('Max retries exceeded');
  }

  Future<String> get(
    String url, {
    Map<String, String>? headers,
    Duration? customTimeout,
  }) async => (await getResponse(
    url,
    headers: headers,
    customTimeout: customTimeout,
  )).body;

  /// Make a GET request expecting HTML response
  ///
  /// This is an alias for [get] but makes intent clearer.
  Future<String> getHtml(
    String url, {
    Map<String, String>? headers,
    Duration? customTimeout,
  }) async {
    return get(url, headers: headers, customTimeout: customTimeout);
  }

  /// Wait before retrying with exponential backoff
  Future<void> _waitBeforeRetry(int attempt) async {
    final delay = retryDelay * (1 << (attempt - 1)); // 1s, 2s, 4s, 8s...
    if (enableLogging) {
      print('[DorarHttpClient] Waiting ${delay.inSeconds}s before retry...');
    }
    await Future<void>.delayed(delay);
  }
}

class DorarHttpResponse {
  const DorarHttpResponse({
    required this.body,
    required this.statusCode,
    required this.encoding,
    required this.fetchedAt,
    this.contentType,
    this.finalUri,
  });
  final String body;
  final int statusCode;
  final String encoding;
  final DateTime fetchedAt;
  final String? contentType;
  final Uri? finalUri;
}
