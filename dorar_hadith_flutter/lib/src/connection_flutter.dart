import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

/// Creates a [DatabaseConnection] factory suited for Flutter environments.
///
/// The returned factory copies the bundled SQLite database into a writable
/// directory (once) before opening it with Drift. Provide a [targetDirectory]
/// if you want persistence across app restarts (for example, an application
/// support directory from `path_provider`).
DatabaseConnection Function() createFlutterConnectionFactory({
  required FlutterDatabaseAssetLoader loadDatabaseBytes,
  Directory? targetDirectory,
  String databaseFileName = 'rawi.db',
}) {
  Directory? resolvedDirectory;
  File? cachedDatabaseFile;

  Future<File> resolveDatabaseFile() async {
    if (cachedDatabaseFile != null && await cachedDatabaseFile!.exists()) {
      return cachedDatabaseFile!;
    }

    resolvedDirectory ??=
        targetDirectory ??
        await Directory.systemTemp.createTemp('dorar_hadith_rawi_db');
    final dbFile = File(p.join(resolvedDirectory!.path, databaseFileName));

    if (!await dbFile.exists()) {
      final bytes = await loadDatabaseBytes();
      await dbFile.parent.create(recursive: true);
      await dbFile.writeAsBytes(bytes, flush: true);
    }

    cachedDatabaseFile = dbFile;
    return dbFile;
  }

  return () {
    return DatabaseConnection(
      LazyDatabase(() async {
        final file = await resolveDatabaseFile();
        return NativeDatabase(file);
      }),
    );
  };
}

/// Signature for loading the bundled database bytes in Flutter.
///
/// This typically wraps `rootBundle.load('packages/dorar_hadith/assets/database/rawi.db')`
/// and returns the `.buffer.asUint8List()` from the resulting [ByteData].
typedef FlutterDatabaseAssetLoader = Future<Uint8List> Function();
