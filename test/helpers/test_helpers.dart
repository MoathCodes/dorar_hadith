import 'package:http/http.dart' as http;

/// Creates a JSON HTTP Response with proper UTF-8 encoding headers
http.Response createJsonUtf8Response(String body, int statusCode) {
  return http.Response(
    body,
    statusCode,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

/// Creates an HTTP Response with proper UTF-8 encoding headers
///
/// This is essential for Arabic content in test mock responses.
/// Without the charset=utf-8 header, the http package may fail to
/// properly handle Arabic Unicode characters.
http.Response createUtf8Response(String body, int statusCode) {
  return http.Response(
    body,
    statusCode,
    headers: {'content-type': 'text/html; charset=utf-8'},
  );
}
