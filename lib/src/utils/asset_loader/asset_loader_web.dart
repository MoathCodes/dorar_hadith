import 'dart:async';

import 'package:http/http.dart' as http;

import 'asset_loader_base.dart';

AssetLoaderBuilder createDefaultAssetLoaderBuilder() {
  return () => WebAssetLoader();
}

/// Asset loader implementation for web environments.
///
/// Fetches assets using HTTP relative to [Uri.base].
class WebAssetLoader implements AssetLoader {
  final http.Client _client;

  final Uri _baseUri;
  WebAssetLoader({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri = baseUri ?? Uri.base;

  @override
  Future<String> loadString(String path) async {
    final uri = _resolve(path);

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw AssetLoaderException(
          'Failed to load asset: HTTP ${response.statusCode}',
          path: path,
        );
      }
      return response.body;
    } catch (error) {
      throw AssetLoaderException(
        'Failed to load asset via HTTP: $uri',
        path: path,
        cause: error,
      );
    }
  }

  Uri _resolve(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Uri.parse(path);
    }
    return _baseUri.resolve(path);
  }
}
