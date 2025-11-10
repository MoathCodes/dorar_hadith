import 'asset_loader_base.dart';

/// Registers the [FlutterAssetLoader] as the default asset loader.
///
/// Call this from Flutter apps after providing the `rootBundle.loadString`
/// function (or a compatible asset bundle loader).
void configureFlutterAssetLoader({
  required Future<String> Function(String key) bundleLoader,
  String Function(String path)? keyResolver,
}) {
  registerDefaultAssetLoader(
    () => FlutterAssetLoader(
      bundleLoader: bundleLoader,
      keyResolver: keyResolver,
    ),
  );
}

/// Asset loader that delegates to a Flutter [AssetBundle].
///
/// This implementation does not import Flutter directly to keep the core
/// package platform-agnostic. Supply [bundleLoader] with
/// `rootBundle.loadString` from `package:flutter/services.dart` when using
/// inside a Flutter application.
class FlutterAssetLoader implements AssetLoader {
  final Future<String> Function(String key) _bundleLoader;

  final String Function(String path) _keyResolver;
  FlutterAssetLoader({
    required Future<String> Function(String key) bundleLoader,
    String Function(String path)? keyResolver,
  }) : _bundleLoader = bundleLoader,
       _keyResolver = keyResolver ?? _defaultResolver;

  @override
  Future<String> loadString(String path) {
    final key = _keyResolver(path);
    return _bundleLoader(key);
  }

  static String _defaultResolver(String path) {
    if (path.startsWith('packages/')) {
      return path;
    }
    return 'packages/dorar_hadith/$path';
  }
}
