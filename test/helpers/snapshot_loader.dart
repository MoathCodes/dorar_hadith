import 'dart:convert';
import 'dart:io';

/// Get just the response body from snapshot
///
/// This is the most commonly used function - returns the actual
/// API response (HTML or JSON) as a string.
///
/// Example:
/// ```dart
/// final html = getSnapshotBody('hadith_search_site');
/// final doc = HtmlHelper.parseHtml(html);
/// ```
String getSnapshotBody(String name) {
  final snapshot = loadSnapshot(name);
  return snapshot['body'] as String;
}

/// Get response headers from snapshot
///
/// Returns headers as a map of String -> String
Map<String, String> getSnapshotHeaders(String name) {
  final snapshot = loadSnapshot(name);
  final headers = snapshot['headers'] as Map<String, dynamic>;
  return headers.map((key, value) => MapEntry(key, value.toString()));
}

/// Get snapshot metadata
///
/// Returns a map with captured_at, url, and description
Map<String, String> getSnapshotMetadata(String name) {
  final snapshot = loadSnapshot(name);
  return {
    'captured_at': snapshot['captured_at'] as String,
    'url': snapshot['url'] as String,
    'description': snapshot['description'] as String,
  };
}

/// Get HTTP status code from snapshot
int getSnapshotStatusCode(String name) {
  final snapshot = loadSnapshot(name);
  return snapshot['status_code'] as int;
}

/// Check if snapshot exists
bool hasSnapshot(String name) {
  final file = File('test/fixtures/api_snapshots/$name.json');
  return file.existsSync();
}

/// List all available snapshots
List<String> listSnapshots() {
  final dir = Directory('test/fixtures/api_snapshots');
  if (!dir.existsSync()) {
    return [];
  }

  return dir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .map((file) {
        final name = file.path.split('/').last;
        return name.replaceAll('.json', '');
      })
      .toList();
}

/// Helper functions for loading captured API response snapshots in tests.
///
/// These functions load real API responses that were captured using
/// `tool/capture_api_responses.dart` and saved as JSON files.
///
/// This allows tests to use authentic API data without making network calls.

/// Load complete snapshot with all metadata
///
/// Returns a map with:
/// - captured_at: ISO 8601 timestamp
/// - url: Original request URL
/// - description: Human-readable description
/// - status_code: HTTP status code
/// - headers: Response headers
/// - body: Response body (HTML or JSON string)
/// - content_length: Body size in bytes
Map<String, dynamic> loadSnapshot(String name) {
  final file = File('test/fixtures/api_snapshots/$name.json');
  if (!file.existsSync()) {
    throw Exception(
      'Snapshot not found: $name.json\n'
      'Run: dart run tool/capture_api_responses.dart',
    );
  }
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}
