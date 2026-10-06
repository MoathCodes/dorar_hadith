import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:html/parser.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:dorar_hadith/src/database/reference_migration.dart';
import 'package:dorar_hadith/src/utils/arabic_search.dart';

/// Produce candidates only. Run capture_upstream_contracts.dart first for fresh sources.
Future<void> main(List<String> args) async {
  if (args.contains('--fetch')) {
    final result = await Process.run('fvm', [
      'dart',
      'run',
      'tool/capture_upstream_contracts.dart',
      '--force',
      'search_0',
      'rawi_0',
      'rawi_1',
      'rawi_2',
      'rawi_3',
    ]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    if (result.exitCode != 0) exit(result.exitCode);
  }
  final output = Directory(
    args.where((a) => !a.startsWith('--')).firstOrNull ??
        '/tmp/dorar-reference-candidate',
  );
  if (await output.exists()) {
    throw ArgumentError('Candidate directory already exists: ${output.path}');
  }
  await output.create(recursive: true);
  final captures = <Map<String, dynamic>>[];
  Map<String, dynamic> capture(String name) {
    final data = jsonDecode(
      File('test/fixtures/upstream/$name.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    if (data['statusCode'] != 200 ||
        sha256.convert(utf8.encode(data['body'] as String)).toString() !=
            data['sha256']) {
      throw FormatException('Invalid capture: $name');
    }
    captures.add(data);
    return data;
  }

  final page = parse(capture('search_0')['body'] as String);
  final diffs = <String, dynamic>{};
  Future<void> choices(String name, String selector) async {
    final prior = (jsonDecode(
      File('test/fixtures/reference_baseline/$name.json').readAsStringSync(),
    ) as List).cast<Map<String, dynamic>>();
    final old = {for (final row in prior) row['key'] as String: row};
    final current = <String, Map<String, dynamic>>{};
    for (final option in page.querySelectorAll('$selector option')) {
      final id = option.attributes['value']!;
      if (current.containsKey(id)) {
        throw FormatException('Duplicate $name ID $id');
      }
      final label = option.text.trim();
      current[id] = {
        'key': id,
        'value': label,
        'currentSelectable': true,
        'historicalNames': <String>{
          ...?(old[id]?['historicalNames'] as List?)?.cast<String>(),
          if (old[id] != null && old[id]!['value'] != label)
            old[id]!['value'] as String,
        }.toList(),
      };
    }
    if (current.length < 100) throw FormatException('Incomplete $name select');
    final removed = old.keys.where((id) => !current.containsKey(id)).toList();
    final rows = [
      ...current.values,
      for (final id in removed) {...old[id]!, 'currentSelectable': false},
    ];
    diffs[name] = {
      'added': current.keys.where((id) => !old.containsKey(id)).toList(),
      'historical': removed,
      'renamed': [
        for (final id in current.keys)
          if (old[id] != null && old[id]!['value'] != current[id]!['value'])
            {
              'id': id,
              'before': old[id]!['value'],
              'after': current[id]!['value'],
            },
      ],
    };
    await File('${output.path}/$name.json')
        .writeAsString('${const JsonEncoder.withIndent('  ').convert(rows)}\n');
  }

  await choices('book', '#s');
  await choices('mohdith', '#m');
  final dbPath = '${output.path}/rawi.db';
  await migrateReferenceDatabase(
    inputPath: 'test/fixtures/reference_baseline/rawi.db',
    outputPath: dbPath,
  );
  final db = sqlite3.open(dbPath);
  final oldCount = db.select('SELECT COUNT(*) AS n FROM rawi').single['n'];
  final added = <int>[], renamed = <Map<String, dynamic>>[];
  for (var i = 0; i < 4; i++) {
    final rows = jsonDecode(capture('rawi_$i')['body'] as String) as List;
    for (final row in rows) {
      final id = row['value'] as int, label = row['text'] as String;
      final old = db.select('SELECT value FROM rawi WHERE key = ?', [id]);
      if (old.isEmpty) {
        added.add(id);
      } else if (old.single['value'] != label) {
        renamed.add({'id': id, 'before': old.single['value'], 'after': label});
      }
      db.execute('INSERT OR REPLACE INTO rawi VALUES (?, ?, ?)', [
        id,
        label,
        normalizeArabicSearch(label.toLowerCase()),
      ]);
    }
  }
  db.execute('VACUUM');
  final rawiCount = db.select('SELECT COUNT(*) AS n FROM rawi').single['n'];
  if (db.select('PRAGMA integrity_check').single.values.single != 'ok') {
    throw const FormatException('Database integrity failed');
  }
  db.close();
  diffs['rawi'] = {
    'baselineCount': oldCount,
    'added': added,
    'renamed': renamed,
    'count': rawiCount,
  };
  final collections = <String, dynamic>{};
  for (final name in ['book', 'mohdith', 'rawi']) {
    final file = File('${output.path}/$name.${name == 'rawi' ? 'db' : 'json'}');
    collections[name] = {
      'sha256': sha256.convert(await file.readAsBytes()).toString(),
      'count': name == 'rawi'
          ? rawiCount
          : (jsonDecode(await file.readAsString()) as List).length,
      'coverage': name == 'rawi'
          ? 'partial'
          : 'currentSelectionWithHistoricalEntries',
      'method': name == 'rawi'
          ? 'historical snapshot plus four direct autocomplete captures; no complete-coverage claim'
          : 'direct complete search-page select plus retained historical IDs',
    };
  }
  final manifest = {
    'snapshotVersion': '2026-10-06.1',
    'schemaVersion': 2,
    'normalizationVersion': 1,
    'generatedAt':
        (captures.map((c) => c['capturedAt'] as String).toList()..sort()).last,
    'sources': captures
        .map(
          (c) => {
            'url': c['url'],
            'capturedAt': c['capturedAt'],
            'sha256': c['sha256'],
          },
        )
        .toList(),
    'collections': collections,
  };
  await File(
    '${output.path}/reference_manifest.json',
  ).writeAsString('${const JsonEncoder.withIndent('  ').convert(manifest)}\n');
  await File('${output.path}/reference_diff.json')
      .writeAsString('${const JsonEncoder.withIndent('  ').convert(diffs)}\n');
  stdout.writeln('Validated candidate snapshot: ${output.path}');
}
