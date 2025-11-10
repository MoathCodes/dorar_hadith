import 'dart:io';
import 'dart:isolate';

import 'asset_loader_base.dart';

AssetLoaderBuilder createDefaultAssetLoaderBuilder() {
  return () => FileAssetLoader();
}

/// Asset loader implementation for Dart CLI applications.
///
/// Reads files directly from the file system using dart:io [File].
class FileAssetLoader implements AssetLoader {
  /// Base directory for resolving asset paths.
  ///
  /// Defaults to the current working directory.
  final String basePath;

  /// Creates a file-based asset loader.
  ///
  /// [basePath] defaults to the current directory if not specified.
  FileAssetLoader({String? basePath})
    : basePath = basePath ?? Directory.current.path;

  @override
  Future<String> loadString(String path) async {
    // 1) Try resolve inside the installed package (pub cache)
    final pkgUri = await Isolate.resolvePackageUri(
      Uri.parse('package:dorar_hadith/$path'),
    );
    if (pkgUri != null) {
      final pkgFile = File.fromUri(pkgUri);
      if (await pkgFile.exists()) {
        try {
          return await pkgFile.readAsString();
        } catch (error) {
          throw AssetLoaderException(
            'Failed to read asset file: ${pkgFile.path}',
            path: path,
            cause: error,
          );
        }
      }
    }

    // 2) Fallback to resolving relative to the current directory
    final file = File(_resolvePath(path));
    if (await file.exists()) {
      try {
        return await file.readAsString();
      } catch (error) {
        throw AssetLoaderException(
          'Failed to read asset file: ${file.path}',
          path: path,
          cause: error,
        );
      }
    }

    // Not found in either location
    throw AssetLoaderException(
      'Asset file not found. Tried package asset and local filesystem for: $path',
      path: path,
    );
  }

  String _resolvePath(String path) {
    if (path.startsWith('/')) {
      return path;
    }
    return '$basePath/$path';
  }
}
