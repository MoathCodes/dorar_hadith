/// Flutter integration for [dorar_hadith](https://pub.dev/packages/dorar_hadith).
///
/// Call [DorarHadithFlutter.ensureInitialized] once in `main()` before using
/// offline reference data or the narrator database.
library;

import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'src/asset_loader_flutter.dart';
import 'src/connection_flutter.dart';

export 'src/asset_loader_flutter.dart'
    show FlutterAssetLoader, configureFlutterAssetLoader;
export 'src/connection_flutter.dart'
    show FlutterDatabaseAssetLoader, createFlutterConnectionFactory;

/// Entry point for wiring [dorar_hadith] in Flutter applications.
abstract final class DorarHadithFlutter {
  static bool _initialized = false;

  /// Returns `true` after [ensureInitialized] has completed successfully.
  static bool get isInitialized => _initialized;

  /// Wires asset loading and the offline `rawi.db` database for Flutter.
  ///
  /// This method is idempotent — subsequent calls return immediately.
  ///
  /// By default, [databaseDirectory] resolves to the application support
  /// directory from `path_provider`, so the copied `rawi.db` persists across
  /// restarts. Pass a custom [databaseDirectory] to override the location.
  static Future<void> ensureInitialized({Directory? databaseDirectory}) async {
    if (_initialized) return;

    configureFlutterAssetLoader(bundleLoader: rootBundle.loadString);

    final directory =
        databaseDirectory ?? await getApplicationSupportDirectory();

    RawiDatabase.configureConnection(
      createFlutterConnectionFactory(
        targetDirectory: directory,
        loadDatabaseBytes: () async {
          final data = await rootBundle.load(
            'packages/dorar_hadith/assets/database/rawi.db',
          );
          return data.buffer.asUint8List();
        },
      ),
    );

    _initialized = true;
  }
}
