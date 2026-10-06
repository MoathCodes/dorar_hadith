/// Flutter integration for [dorar_hadith](https://pub.dev/packages/dorar_hadith).
///
/// Call [DorarHadithFlutter.ensureInitialized] once in `main()` before using
/// offline reference data or the narrator database.
library;

import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'src/adapter_exception.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'src/asset_loader_flutter.dart';
import 'src/connection_flutter.dart';

export 'src/adapter_exception.dart';
export 'src/asset_loader_flutter.dart'
    show FlutterAssetLoader, configureFlutterAssetLoader;
export 'src/connection_flutter.dart'
    show
        FlutterDatabaseAssetLoader,
        createFlutterCacheConnectionFactory,
        createFlutterConnectionFactory,
        installManagedReferenceSnapshot;

/// Entry point for wiring [dorar_hadith] in Flutter applications.
abstract final class DorarHadithFlutter {
  static bool _initialized = false;
  static Future<void>? _inFlight;
  static String? _configuration;

  static bool get isInitialized => _initialized;

  /// Concurrent calls share initialization. Failures may be retried.
  /// Changing the database directory requires a new process.
  static Future<void> ensureInitialized({Directory? databaseDirectory}) {
    final configuration = databaseDirectory == null
        ? '<application-support>'
        : p.normalize(databaseDirectory.absolute.path);
    if (_inFlight != null) {
      if (_configuration != configuration) {
        return Future.error(
          const DorarFlutterAdapterException(
            FlutterAdapterFailure.configurationConflict,
            'Initialization already uses a different database directory',
          ),
        );
      }
      return _inFlight!;
    }
    _configuration = configuration;
    final attempt = _initialize(databaseDirectory);
    _inFlight = attempt.then(
      (_) {
        _initialized = true;
      },
      onError: (Object error, StackTrace stack) {
        _inFlight = null;
        _configuration = null;
        _initialized = false;
        Error.throwWithStackTrace(error, stack);
      },
    );
    return _inFlight!;
  }

  static Future<void> _initialize(Directory? databaseDirectory) async {
    late ReferenceManifest manifest;
    late Uint8List bytes;
    try {
      manifest = ReferenceManifest.decode(
        await rootBundle.loadString(
          'packages/dorar_hadith/assets/data/reference_manifest.json',
          cache: false,
        ),
      );
      for (final name in ['book', 'mohdith']) {
        final asset = await rootBundle.load(
          'packages/dorar_hadith/assets/data/$name.json',
        );
        manifest.validateBytes(
          name,
          asset.buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes),
        );
      }
      final asset = await rootBundle.load(
        'packages/dorar_hadith/assets/database/rawi.db',
      );
      bytes = asset.buffer.asUint8List(
        asset.offsetInBytes,
        asset.lengthInBytes,
      );
      manifest.validateBytes('rawi', bytes);
    } on FormatException catch (e) {
      throw DorarFlutterAdapterException(
        FlutterAdapterFailure.integrity,
        'Reference manifest or asset verification failed',
        cause: e,
      );
    } on Object catch (e) {
      throw DorarFlutterAdapterException(
        FlutterAdapterFailure.missingAsset,
        'Required transitive Dorar reference asset could not be loaded',
        cause: e,
      );
    }
    if (kIsWeb) {
      if (databaseDirectory != null) {
        throw const DorarFlutterAdapterException(
          FlutterAdapterFailure.configurationConflict,
          'Browser initialization does not accept a native directory',
        );
      }
      configureFlutterAssetLoader(bundleLoader: rootBundle.loadString);
      RawiDatabase.resetConnection();
      CacheDatabase.resetConnection();
      return;
    }
    final directory =
        databaseDirectory ?? await getApplicationSupportDirectory();
    await installManagedReferenceSnapshot(
      directory: directory,
      manifest: manifest,
      bytes: bytes,
    );
    final referenceFactory = createFlutterConnectionFactory(
      targetDirectory: directory,
      loadDatabaseBytes: () async => bytes,
      manifest: manifest,
    );
    final cacheFactory = createFlutterCacheConnectionFactory(
      targetDirectory: directory,
    );
    configureFlutterAssetLoader(bundleLoader: rootBundle.loadString);
    RawiDatabase.configureConnection(referenceFactory);
    CacheDatabase.configureConnection(cacheFactory);
  }
}
