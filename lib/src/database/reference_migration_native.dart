import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

import '../utils/arabic_search.dart';

/// Creates a verified schema-2 copy. The input is opened read-only.
/// Existing output files are never replaced.
Future<void> migrateReferenceDatabase({
  required String inputPath,
  required String outputPath,
}) async {
  final output = File(outputPath);
  if (await output.exists()) {
    throw ArgumentError('Output already exists: $outputPath');
  }
  final source = sqlite3.open(inputPath, mode: OpenMode.readOnly);
  Database? target;
  var ownsOutput = false;
  try {
    final version = source.select('PRAGMA user_version').single.values.single;
    if (version != 1 && version != 2) {
      throw FormatException('Unsupported reference schema: $version');
    }
    final rows = source.select('SELECT key, value FROM rawi ORDER BY key');
    await output.parent.create(recursive: true);
    await output.create(exclusive: true);
    ownsOutput = true;
    target = sqlite3.open(outputPath);
    target.execute(
      'CREATE TABLE rawi (key INTEGER NOT NULL PRIMARY KEY, value TEXT NOT NULL, normalized_value TEXT NOT NULL)',
    );
    target.execute('BEGIN');
    final insert = target.prepare('INSERT INTO rawi VALUES (?, ?, ?)');
    try {
      for (final row in rows) {
        final label = row['value'] as String;
        insert.execute([
          row['key'],
          label,
          normalizeArabicSearch(label.toLowerCase()),
        ]);
      }
    } finally {
      insert.close();
    }
    target.execute('PRAGMA user_version = 2');
    target.execute('COMMIT');
    if (target.select('PRAGMA integrity_check').single.values.single != 'ok' ||
        target.select('SELECT COUNT(*) FROM rawi').single.values.single !=
            rows.length) {
      throw const FormatException('Reference copy failed verification');
    }
  } catch (_) {
    target?.close();
    target = null;
    if (ownsOutput && await output.exists()) await output.delete();
    rethrow;
  } finally {
    target?.close();
    source.close();
  }
}
