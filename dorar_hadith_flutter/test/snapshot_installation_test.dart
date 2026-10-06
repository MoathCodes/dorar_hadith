import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

Future<(ReferenceManifest, Uint8List)> snapshot(
  Directory directory,
  String version,
  int id,
) async {
  final file = File('${directory.path}/input-$version.db');
  final database = sqlite.sqlite3.open(file.path);
  database.execute(
    'CREATE TABLE rawi (key INTEGER NOT NULL PRIMARY KEY, value TEXT NOT NULL, normalized_value TEXT NOT NULL)',
  );
  database.execute('INSERT INTO rawi VALUES (?, ?, ?)', [
    id,
    'أبو هريرة',
    'ابو هريره',
  ]);
  database.execute('PRAGMA user_version = 2');
  database.close();
  final bytes = await file.readAsBytes();
  final hash = sha256.convert(bytes).toString();
  final manifest = ReferenceManifest.decode(
    jsonEncode({
      'snapshotVersion': version,
      'schemaVersion': 2,
      'normalizationVersion': 1,
      'collections': {
        for (final name in ['book', 'mohdith', 'rawi'])
          name: {'sha256': hash, 'count': 1, 'coverage': 'partial'},
      },
    }),
  );
  return (manifest, bytes);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dorar-adapter-upgrade');
  });
  tearDown(() => dir.delete(recursive: true));
  test(
    'A to B upgrades preserve legacy reference, cache and unrelated storage',
    () async {
      final legacy = File('${dir.path}/rawi.db');
      await legacy.writeAsString('caller owned');
      final cache = File('${dir.path}/cache.db');
      await cache.writeAsString('mutable cache sentinel');
      final other = File('${dir.path}/notes.txt');
      await other.writeAsString('unrelated');
      final (a, aBytes) = await snapshot(dir, 'snapshot-A', 1);
      final (b, bBytes) = await snapshot(dir, 'snapshot-B', 2);
      final oldFile = await installManagedReferenceSnapshot(
        directory: dir,
        manifest: a,
        bytes: aBytes,
      );
      final newFile = await installManagedReferenceSnapshot(
        directory: dir,
        manifest: b,
        bytes: bBytes,
      );
      expect(newFile.path, isNot(oldFile.path));
      expect(await oldFile.exists(), isTrue);
      expect(await legacy.readAsString(), 'caller owned');
      expect(await cache.readAsString(), 'mutable cache sentinel');
      expect(await other.readAsString(), 'unrelated');
      final factory = createFlutterConnectionFactory(
        targetDirectory: dir,
        manifest: b,
        loadDatabaseBytes: () async => bBytes,
      );
      RawiDatabase.configureConnection(factory);
      addTearDown(RawiDatabase.resetConnection);
      final database = RawiDatabase();
      addTearDown(database.close);
      expect((await database.searchRawi('ابو هريره')).single.id, '2');
      expect(await database.getRawiById(1), isNull);
      b.validateBytes('rawi', await newFile.readAsBytes());
    },
  );
  test('concurrent installs are atomic and leave no temporary files', () async {
    final (manifest, bytes) = await snapshot(dir, 'concurrent', 3);
    final files = await Future.wait(
      List.generate(
        6,
        (_) => installManagedReferenceSnapshot(
          directory: dir,
          manifest: manifest,
          bytes: bytes,
        ),
      ),
    );
    expect(files.map((f) => f.path).toSet(), hasLength(1));
    expect(dir.listSync().where((f) => f.path.endsWith('.tmp')), isEmpty);
    manifest.validateBytes('rawi', await files.first.readAsBytes());
  });
  test(
    'corruption is actionable and does not remove other snapshots or cache',
    () async {
      final (manifest, bytes) = await snapshot(dir, 'integrity', 4);
      final file = await installManagedReferenceSnapshot(
        directory: dir,
        manifest: manifest,
        bytes: bytes,
      );
      await file.writeAsString('corruption');
      await expectLater(
        installManagedReferenceSnapshot(
          directory: dir,
          manifest: manifest,
          bytes: bytes,
        ),
        throwsA(
          isA<DorarFlutterAdapterException>().having(
            (e) => e.failure,
            'failure',
            FlutterAdapterFailure.integrity,
          ),
        ),
      );
      expect(await file.readAsString(), 'corruption');
      final bad = Uint8List.fromList(bytes)..[0] = 0;
      await expectLater(
        installManagedReferenceSnapshot(
          directory: dir,
          manifest: manifest,
          bytes: bad,
        ),
        throwsA(isA<DorarFlutterAdapterException>()),
      );
    },
  );
  test(
    'a custom path created during asset loading is never overwritten',
    () async {
      final (_, bytes) = await snapshot(dir, 'ownership-race', 5);
      final owned = File('${dir.path}/race.db');
      RawiDatabase.configureConnection(
        createFlutterConnectionFactory(
          targetDirectory: dir,
          databaseFileName: 'race.db',
          loadDatabaseBytes: () async {
            await owned.writeAsString('another owner');
            return bytes;
          },
        ),
      );
      addTearDown(RawiDatabase.resetConnection);
      final database = RawiDatabase();
      await expectLater(
        database.countRawi(),
        throwsA(
          isA<DorarFlutterAdapterException>().having(
            (e) => e.cause,
            'exclusive creation failure',
            isA<FileSystemException>(),
          ),
        ),
      );
      await expectLater(
        database.close(),
        throwsA(isA<DorarFlutterAdapterException>()),
      );
      expect(await owned.readAsString(), 'another owner');
    },
  );
  test(
    'custom schema-1 ownership is rejected without modifying original',
    () async {
      final file = File('${dir.path}/custom.db');
      final source = sqlite.sqlite3.open(file.path);
      source.execute(
        'CREATE TABLE rawi (key INTEGER PRIMARY KEY, value TEXT NOT NULL)',
      );
      source.execute('PRAGMA user_version=1');
      source.close();
      final hash = sha256.convert(await file.readAsBytes());
      RawiDatabase.configureConnection(
        createFlutterConnectionFactory(
          targetDirectory: dir,
          databaseFileName: 'custom.db',
          loadDatabaseBytes: () async => throw StateError('must not overwrite'),
        ),
      );
      addTearDown(RawiDatabase.resetConnection);
      final database = RawiDatabase();
      await expectLater(
        database.countRawi(),
        throwsA(
          isA<DorarFlutterAdapterException>().having(
            (e) => e.failure,
            'failure',
            FlutterAdapterFailure.incompatibleSchema,
          ),
        ),
      );
      await expectLater(
        database.close(),
        throwsA(isA<DorarFlutterAdapterException>()),
      );
      expect(sha256.convert(await file.readAsBytes()), hash);
    },
  );
}
