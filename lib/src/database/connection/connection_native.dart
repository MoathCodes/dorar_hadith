import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

/// Opens a connection to the rawi.db SQLite database for native platforms.
///
/// This function is used by the Dart CLI and desktop applications.
/// For Flutter, use connection_flutter.dart instead.
DatabaseConnection openConnection() {
  return DatabaseConnection(
    LazyDatabase(() async {
      // First try resolving the database inside the installed package
      // (works when this library is used as a dependency)
      final packageDbUri = await Isolate.resolvePackageUri(
        Uri.parse('package:dorar_hadith/assets/database/rawi.db'),
      );

      if (packageDbUri != null) {
        final packageDbFile = File.fromUri(packageDbUri);
        if (await packageDbFile.exists()) {
          return NativeDatabase(packageDbFile);
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
          return NativeDatabase(file);
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
