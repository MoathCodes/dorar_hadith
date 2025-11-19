import 'asset_loader_base.dart';
import 'asset_loader_io.dart'
    if (dart.library.js) 'asset_loader_web.dart'
    as platform;

export 'asset_loader_base.dart';
export 'asset_loader_flutter.dart';
export 'asset_loader_io.dart' if (dart.library.js) 'asset_loader_web.dart';

// ignore: unused_field
final _assetLoaderRegistration = (() {
  registerDefaultAssetLoader(platform.createDefaultAssetLoaderBuilder());
  return true;
})();

/// Creates the default [AssetLoader] for the current platform.
AssetLoader createAssetLoader() {
  ensureDefaultAssetLoaderRegistered();
  return AssetLoader();
}

/// Ensures the platform-default [AssetLoader] is registered and ready.
///
/// Useful for environments where the library might be tree-shaken or when
/// consumers want explicit control over initialization.
bool ensureDefaultAssetLoaderRegistered() => _assetLoaderRegistration;
