// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Captures live Dorar.net responses as snapshot fixtures for integration tests.
///
/// Usage (from packages/dorar_hadith):
/// ```bash
/// dart run tool/capture_api_snapshots.dart [snapshot_name ...]
/// ```
Future<void> main(List<String> args) async {
  final targets = args.isNotEmpty
      ? args
      : ['sharh_by_id', 'mohdith_bukhari'];

  for (final name in targets) {
    final spec = _snapshotSpecs[name];
    if (spec == null) {
      print('Unknown snapshot: $name');
      continue;
    }
    await _capture(name, spec.url, spec.description);
  }
}

Future<void> _capture(String name, String url, String description) async {
  print('Capturing $name from $url ...');
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Failed to capture $name: HTTP ${response.statusCode}');
  }

  final headers = <String, String>{};
  response.headers.forEach((key, value) {
    headers[key] = value.replaceAll(
      RegExp(r'XSRF-TOKEN=[^;]+|laravel_session=[^;]+'),
      'REDACTED',
    );
  });

  final snapshot = {
    'captured_at': DateTime.now().toIso8601String(),
    'url': url,
    'description': description,
    'status_code': response.statusCode,
    'headers': headers,
    'body': response.body,
    'content_length': response.body.length,
  };

  final output = File('test/fixtures/api_snapshots/$name.json');
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(snapshot));
  print('  wrote ${output.path} (${response.body.length} bytes)');
}

class _SnapshotSpec {
  const _SnapshotSpec({required this.url, required this.description});

  final String url;
  final String description;
}

const _snapshotSpecs = <String, _SnapshotSpec>{
  'sharh_by_id': _SnapshotSpec(
    url: 'https://www.dorar.net/hadith/sharh/2981',
    description: 'Sharh page for hadith explanation ID 2981',
  ),
  'mohdith_bukhari': _SnapshotSpec(
    url: 'https://www.dorar.net/hadith/mhd/256',
    description: 'Imam Al-Bukhari scholar page',
  ),
};
