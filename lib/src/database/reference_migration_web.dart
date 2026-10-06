/// File migration is available on native platforms. Browser snapshots are versioned.
Future<void> migrateReferenceDatabase({
  required String inputPath,
  required String outputPath,
}) => Future.error(
  UnsupportedError(
    'Use the native migration helper to prepare a schema-2 browser snapshot',
  ),
);
