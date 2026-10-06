import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:path/path.dart' as p;

/// Opens a connection to the cache.db SQLite database for native platforms.
DatabaseConnection openCacheConnection() {
  return DatabaseConnection(
    LazyDatabase(() async {
      final dbFolder = Directory.current;
      final file = File(p.join(dbFolder.path, 'cache.db'));
      return NativeDatabase(file);
    }),
  );
}

/// Opens a connection to the rawi.db SQLite database for native platforms.
///
/// This function is used by the Dart CLI and desktop applications.
/// For Flutter, use the [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter) package.
DatabaseConnection openConnection() {
  return DatabaseConnection(
    LazyDatabase(() async {
      // First try resolving the database inside the installed package
      // (works when this library is used as a dependency)
      final packageDbUri = await Isolate.resolvePackageUri(
        Uri.parse('package:dorar_hadith/dorar_hadith.dart'),
      );

      if (packageDbUri != null) {
        final packageDbFile = File.fromUri(
          packageDbUri.resolve('../assets/database/rawi.db'),
        );
        if (await packageDbFile.exists()) {
          return NativeDatabase.opened(
            sqlite.sqlite3.open(
              packageDbFile.path,
              mode: sqlite.OpenMode.readOnly,
            ),
            enableMigrations: false,
          );
        }
      }

      // Fallback: Try to find the database in multiple possible locations
      // relative to the current working directory (useful for local runs,
      // examples, and tests).
      final possiblePaths = <String>[
        'assets/database/rawi.db',
        '../assets/database/rawi.db',
        '../../assets/database/rawi.db',
        p.join(Directory.current.path, 'assets/database/rawi.db'),
        p.join(Directory.current.parent.path, 'assets/database/rawi.db'),
      ];

      for (final path in possiblePaths) {
        final file = File(path);
        if (await file.exists()) {
          return NativeDatabase.opened(
            sqlite.sqlite3.open(file.path, mode: sqlite.OpenMode.readOnly),
            enableMigrations: false,
          );
        }
      }

      // If nothing was found, throw a helpful error.
      throw Exception(
        'Database file not found. Tried package asset and paths:\n'
        '${['package:dorar_hadith/assets/database/rawi.db', ...possiblePaths].map((p) => '  - $p').join('\n')}\n'
        'Ensure rawi.db is bundled in assets/database/ (it is included in the package).',
      );
    }),
  );
}
