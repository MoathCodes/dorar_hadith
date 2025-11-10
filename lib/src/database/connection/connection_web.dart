import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:http/http.dart' as http;

/// Opens a connection to the bundled rawi.db for web platforms using Drift's
/// WebAssembly backend.
///
/// Requirements for consumers (Flutter Web or Dart Web apps):
/// - Ensure `sqlite3.wasm` and `drift_worker.dart.js` are served by your app.
///   The simplest setup is to place both files in your web root so they are
///   available at `/sqlite3.wasm` and `/drift_worker.dart.js`.
/// - The initial database file is loaded from this package's assets via HTTP.
///   This function tries common asset URLs used by Flutter Web:
///     - `assets/packages/dorar_hadith/assets/database/rawi.db`
///     - `packages/dorar_hadith/assets/database/rawi.db`
///     - `assets/database/rawi.db` (fallback if an app copies the asset)
///
/// For details, see: https://drift.simonbinder.eu/platforms/web/
DatabaseConnection openConnection() {
  return DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'dorar_hadith_rawi_db',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.dart.js'),
        initializeDatabase: () async {
          final bytes = await _loadBundledDatabaseBytes();
          if (bytes == null) {
            throw Exception(
              'Failed to initialize web database: Could not fetch bundled rawi.db.\n'
              'Ensure the asset is available at one of:\n'
              '  - assets/packages/dorar_hadith/assets/database/rawi.db\n'
              '  - packages/dorar_hadith/assets/database/rawi.db\n'
              '  - assets/database/rawi.db (app-provided fallback)\n',
            );
          }
          return bytes;
        },
      );

      // Optionally, apps may inspect result.missingFeatures / chosenImplementation
      // to warn users about degraded persistence modes. We keep library output quiet.

      return result.resolvedExecutor;
    }),
  );
}

Future<Uint8List?> _loadBundledDatabaseBytes() async {
  // Try common web asset locations, in order.
  final candidates = <String>[
    // Flutter Web-packed package assets
    'assets/packages/dorar_hadith/assets/database/rawi.db',
    // Some serving setups expose package assets without the leading assets/
    'packages/dorar_hadith/assets/database/rawi.db',
    // App-managed fallback (if consumers copy the DB asset themselves)
    'assets/database/rawi.db',
  ];

  for (final path in candidates) {
    final bytes = await _tryFetchBytes(path);
    if (bytes != null) return bytes;
  }

  return null;
}

Future<Uint8List?> _tryFetchBytes(String relativePath) async {
  final uri = Uri.base.resolve(relativePath);
  try {
    final res = await http.get(uri);
    if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
      return res.bodyBytes;
    }
  } catch (_) {
    // Ignore and try next candidate
  }
  return null;
}
