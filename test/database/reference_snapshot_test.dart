import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:test/test.dart';

void main() {
  test('bundled manifest verifies every committed snapshot', () async {
    final manifest = ReferenceManifest.decode(
      await File('assets/data/reference_manifest.json').readAsString(),
    );
    for (final name in ['book', 'mohdith', 'rawi']) {
      final path = name == 'rawi'
          ? 'assets/database/rawi.db'
          : 'assets/data/$name.json';
      manifest.validateBytes(name, await File(path).readAsBytes());
    }
    final database = RawiDatabase();
    addTearDown(database.close);
    expect(await database.countRawi(), manifest.rawiCount);
  });
  test('Arabic count and search use identical normalization and deterministic paging', () async {
    final database = RawiDatabase();
    addTearDown(database.close);
    for (final variants in [
      ['أبو هريرة', 'ابو هريره', 'أَبُو هُرَيْرَة', 'ابـو هـريره'],
      ['عائشة', 'عائشه', 'عَائِشَة'],
      ['عبدالله بن عمر', 'عبدالله بن عُمر'],
    ]) {
      final ids = (await database.searchRawi(
        variants.first,
        limit: 1000,
      )).map((e) => e.id).toList();
      expect(ids, isNotEmpty);
      for (final query in variants) {
        final results = await database.searchRawi(query, limit: 1000);
        expect(results.map((e) => e.id), ids, reason: query);
        expect(await database.countRawi(query: query), results.length);
        expect(
          (await database.searchRawi(
            query,
            limit: 2,
            offset: 1,
          )).map((e) => e.id),
          ids.skip(1).take(2),
        );
      }
    }
    expect(await database.countRawi(query: '%'), 0);
    expect(await database.searchRawi('_'), isEmpty);
    expect(() => database.searchRawi('عمر', offset: -1), throwsArgumentError);
  });
  test(
    'historical scholars remain lookup-only and changed labels searchable',
    () async {
      final scholars = MohdithReferenceService();
      addTearDown(scholars.dispose);
      for (final id in ['227', '233', '291']) {
        expect((await scholars.getMohdithById(id))!.currentSelectable, isFalse);
        expect(
          (await scholars.getAllMohdith(limit: 1000)).map((e) => e.id),
          isNot(contains(id)),
        );
      }
      final books = BookReferenceService();
      addTearDown(books.dispose);
      expect(
        (await books.searchBook('كفاية المستنقع')).map((e) => e.id),
        contains('88'),
      );
    },
  );
  test('concurrent explicit migrations claim one output without deleting another result', () async {
    final dir = await Directory.systemTemp.createTemp(
      'reference-migration-race',
    );
    addTearDown(() => dir.delete(recursive: true));
    final input = '${dir.path}/source.db', output = '${dir.path}/candidate.db';
    await File('test/fixtures/reference_baseline/rawi.db').copy(input);
    final original = sha256.convert(await File(input).readAsBytes());
    final results = await Future.wait(
      List.generate(
        5,
        (_) =>
            migrateReferenceDatabase(inputPath: input, outputPath: output).then(
              (_) => true,
              onError: (Object error) {
                expect(
                  error,
                  anyOf(isA<ArgumentError>(), isA<FileSystemException>()),
                );
                return false;
              },
            ),
      ),
    );
    expect(results.where((v) => v), hasLength(1));
    expect(sha256.convert(await File(input).readAsBytes()), original);
    final database = sqlite.sqlite3.open(
      output,
      mode: sqlite.OpenMode.readOnly,
    );
    try {
      expect(database.select('PRAGMA user_version').single.values.single, 2);
      expect(
        database.select('PRAGMA integrity_check').single.values.single,
        'ok',
      );
      expect(
        database.select('SELECT COUNT(*) FROM rawi').single.values.single,
        11436,
      );
    } finally {
      database.close();
    }
  });
  test('explicit migration makes a verified copy and preserves schema-1 input bytes', () async {
    final dir = await Directory.systemTemp.createTemp('reference-migration');
    addTearDown(() => dir.delete(recursive: true));
    final input = '${dir.path}/custom.db', output = '${dir.path}/managed.db';
    final source = sqlite.sqlite3.open(input);
    source.execute(
      'CREATE TABLE rawi (key INTEGER PRIMARY KEY, value TEXT NOT NULL)',
    );
    source.execute('INSERT INTO rawi VALUES (1, ?)', ['أَبُو هُرَيْرَة']);
    source.execute('PRAGMA user_version = 1');
    source.close();
    final hash = sha256.convert(await File(input).readAsBytes());
    await migrateReferenceDatabase(inputPath: input, outputPath: output);
    expect(sha256.convert(await File(input).readAsBytes()), hash);
    final copy = sqlite.sqlite3.open(output, mode: sqlite.OpenMode.readOnly);
    expect(copy.select('PRAGMA user_version').single.values.single, 2);
    expect(
      copy.select('SELECT value, normalized_value FROM rawi').single.values,
      ['أَبُو هُرَيْرَة', 'ابو هريره'],
    );
    copy.close();
    await expectLater(
      migrateReferenceDatabase(inputPath: input, outputPath: output),
      throwsArgumentError,
    );
    RawiDatabase.configureConnection(
      () => DatabaseConnection(NativeDatabase(File(input))),
    );
    addTearDown(RawiDatabase.resetConnection);
    final incompatible = RawiDatabase();
    addTearDown(incompatible.close);
    await expectLater(
      incompatible.countRawi(),
      throwsA(isA<ReferenceSchemaException>()),
    );
  });
}
