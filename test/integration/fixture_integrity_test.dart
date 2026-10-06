import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';

void main() {
  test('direct-source fixture manifest covers every target and verifies all hashes', () {
    final manifest = jsonDecode(
      File('test/fixtures/upstream_manifest.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final targets = jsonDecode(
      File('tool/upstream_contract_targets.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final entries = manifest['captures'] as List<dynamic>;
    expect(entries, hasLength(manifest['captureCount'] as int));
    expect(entries, hasLength(targets.length));
    final names = <String>{};
    for (final raw in entries) {
      final entry = raw as Map<String, dynamic>;
      final name = entry['name'] as String;
      names.add(name);
      final file = File('test/fixtures/upstream/$name.json');
      final capture =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      expect(
        sha256.convert(file.readAsBytesSync()).toString(),
        entry['captureFileSha256'],
        reason: name,
      );
      expect(
        sha256.convert(utf8.encode(capture['body'] as String)).toString(),
        entry['sha256'],
        reason: name,
      );
      expect(entry['url'], targets[name], reason: name);
      expect(capture['statusCode'], 200, reason: name);
      expect(DateTime.tryParse(entry['capturedAt'] as String), isNotNull);
    }
    expect(names, targets.keys.toSet());
    expect(
      Directory('test/fixtures/upstream').listSync().whereType<File>(),
      hasLength(entries.length),
    );
  });
}
