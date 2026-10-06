import 'dart:io';
import 'dart:math';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'adapter_exception.dart';

typedef FlutterDatabaseAssetLoader = Future<Uint8List> Function();

/// Installs a verified immutable snapshot. Old references and mutable caches remain.
Future<File> installManagedReferenceSnapshot({
  required Directory directory,
  required ReferenceManifest manifest,
  required Uint8List bytes,
}) async {
  try {
    manifest.validateBytes('rawi', bytes);
    await directory.create(recursive: true);
    final destination = File(p.join(directory.path, manifest.databaseFileName));
    if (await destination.exists()) {
      manifest.validateBytes('rawi', await destination.readAsBytes());
      _verifyDatabase(destination, manifest.rawiCount);
      return destination;
    }
    final temporary = File(
      '${destination.path}.$pid.${DateTime.now().microsecondsSinceEpoch}.${Random.secure().nextInt(0x7fffffff)}.tmp',
    );
    try {
      await temporary.writeAsBytes(bytes, flush: true);
      manifest.validateBytes('rawi', await temporary.readAsBytes());
      _verifyDatabase(temporary, manifest.rawiCount);
      // Another installer may have completed while the temporary file was checked.
      if (await destination.exists()) {
        manifest.validateBytes('rawi', await destination.readAsBytes());
      } else {
        try {
          await temporary.rename(destination.path);
        } on FileSystemException {
          if (!await destination.exists()) rethrow;
          manifest.validateBytes('rawi', await destination.readAsBytes());
          _verifyDatabase(destination, manifest.rawiCount);
        }
      }
    } finally {
      if (await temporary.exists()) await temporary.delete();
    }
    return destination;
  } on DorarFlutterAdapterException {
    rethrow;
  } on FormatException catch (e) {
    throw DorarFlutterAdapterException(
      FlutterAdapterFailure.integrity,
      'Bundled reference verification failed',
      cause: e,
    );
  } on Object catch (e) {
    throw DorarFlutterAdapterException(
      FlutterAdapterFailure.installation,
      'Could not install managed reference snapshot',
      cause: e,
    );
  }
}

void _verifyDatabase(File file, int count) {
  final db = sqlite.sqlite3.open(file.path, mode: sqlite.OpenMode.readOnly);
  try {
    if (db.select('PRAGMA user_version').single.values.single != 2) {
      throw const DorarFlutterAdapterException(
        FlutterAdapterFailure.incompatibleSchema,
        'Reference database must use schema 2',
      );
    }
    if (db.select('PRAGMA integrity_check').single.values.single != 'ok' ||
        db.select('SELECT COUNT(*) FROM rawi').single.values.single != count) {
      throw const FormatException('Invalid reference database contents');
    }
    db.select('SELECT normalized_value FROM rawi LIMIT 1');
  } finally {
    db.close();
  }
}

/// A custom filename retains caller ownership. Supply [manifest] for managed upgrades.
DatabaseConnection Function() createFlutterConnectionFactory({
  required FlutterDatabaseAssetLoader loadDatabaseBytes,
  Directory? targetDirectory,
  String databaseFileName = 'rawi.db',
  ReferenceManifest? manifest,
}) {
  Future<File>? pending;
  Future<File> resolve() async {
    final directory =
        targetDirectory ??
        await Directory.systemTemp.createTemp('dorar_hadith_rawi_db');
    if (manifest != null) {
      return installManagedReferenceSnapshot(
        directory: directory,
        manifest: manifest,
        bytes: await loadDatabaseBytes(),
      );
    }
    final file = File(p.join(directory.path, databaseFileName));
    if (!await file.exists()) {
      await file.parent.create(recursive: true);
      final bytes = await loadDatabaseBytes();
      // Claim the caller-owned path after loading: another owner may have
      // created it while the asynchronous loader was running. Never truncate it.
      try {
        await file.create(exclusive: true);
      } on FileSystemException catch (error) {
        throw DorarFlutterAdapterException(
          FlutterAdapterFailure.installation,
          'Custom reference path could not be claimed without overwriting an existing owner',
          cause: error,
        );
      }
      try {
        await file.writeAsBytes(bytes, flush: true);
      } on Object {
        await file.delete();
        rethrow;
      }
    }
    final database = sqlite.sqlite3.open(
      file.path,
      mode: sqlite.OpenMode.readOnly,
    );
    try {
      if (database.select('PRAGMA user_version').single.values.single != 2) {
        throw const DorarFlutterAdapterException(
          FlutterAdapterFailure.incompatibleSchema,
          'Custom reference database requires schema 2; migrate a separate copy first',
        );
      }
    } finally {
      database.close();
    }
    return file;
  }

  Future<File> file() => pending ??= resolve().catchError((Object error) {
    pending = null;
    throw error;
  });
  return () => DatabaseConnection(
    LazyDatabase(() async {
      final reference = await file();
      return NativeDatabase.opened(
        sqlite.sqlite3.open(reference.path, mode: sqlite.OpenMode.readOnly),
        enableMigrations: false,
      );
    }),
  );
}

DatabaseConnection Function() createFlutterCacheConnectionFactory({
  required Directory targetDirectory,
  String databaseFileName = 'cache.db',
}) =>
    () => DatabaseConnection(
      LazyDatabase(() async {
        final file = File(p.join(targetDirectory.path, databaseFileName));
        await file.parent.create(recursive: true);
        return NativeDatabase(file);
      }),
    );
