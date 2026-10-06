import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:drift/drift.dart';

typedef FlutterDatabaseAssetLoader = Future<Uint8List> Function();

/// Browser initialization uses the core versioned WebAssembly connection.
Future<File> installManagedReferenceSnapshot({
  required Directory directory,
  required ReferenceManifest manifest,
  required Uint8List bytes,
}) => Future.error(
  UnsupportedError('Native snapshot installation is unavailable in a browser'),
);
DatabaseConnection Function() createFlutterConnectionFactory({
  required FlutterDatabaseAssetLoader loadDatabaseBytes,
  Directory? targetDirectory,
  String databaseFileName = 'rawi.db',
  ReferenceManifest? manifest,
}) => throw UnsupportedError(
  'Use DorarHadithFlutter.ensureInitialized() without a native directory on web',
);
DatabaseConnection Function() createFlutterCacheConnectionFactory({
  required Directory targetDirectory,
  String databaseFileName = 'cache.db',
}) => throw UnsupportedError(
  'Browser cache storage uses the core WebAssembly connection',
);
