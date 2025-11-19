import 'dart:async';

AssetLoaderBuilder _defaultAssetLoaderBuilder = _unsupportedAssetLoaderBuilder;

AssetLoaderBuilder? _platformAssetLoaderBuilder;

AssetLoaderBuilder _unsupportedAssetLoaderBuilder = () {
  throw UnsupportedError(
    'No AssetLoader has been configured for this platform. '
    'Call AssetLoader.configure or include a platform implementation.',
  );
};

/// Registers the default [AssetLoader] factory for the current platform.
void registerDefaultAssetLoader(AssetLoaderBuilder builder) {
  _platformAssetLoaderBuilder = builder;
  _defaultAssetLoaderBuilder = builder;
}

/// Signature for creating a new [AssetLoader] instance.
typedef AssetLoaderBuilder = AssetLoader Function();

/// Base contract for loading asset contents.
abstract interface class AssetLoader {
  /// Returns an [AssetLoader] for the current platform.
  factory AssetLoader() => _defaultAssetLoaderBuilder();

  /// Reads the contents of an asset file as a string.
  Future<String> loadString(String path);

  /// Overrides the default [AssetLoader] factory globally.
  static void configure(AssetLoaderBuilder builder) {
    _defaultAssetLoaderBuilder = builder;
  }

  /// Restores the platform default [AssetLoader] factory.
  static void reset() {
    _defaultAssetLoaderBuilder =
        _platformAssetLoaderBuilder ?? _unsupportedAssetLoaderBuilder;
  }
}

/// Exception thrown when an asset fails to load.
class AssetLoaderException implements Exception {
  /// Error message describing what went wrong.
  final String message;

  /// The asset path that failed to load.
  final String path;

  /// Optional underlying cause (e.g., IOException).
  final Object? cause;

  AssetLoaderException(this.message, {required this.path, this.cause});

  @override
  String toString() {
    if (cause != null) {
      return 'AssetLoaderException: $message\nCaused by: $cause';
    }
    return 'AssetLoaderException: $message';
  }
}
