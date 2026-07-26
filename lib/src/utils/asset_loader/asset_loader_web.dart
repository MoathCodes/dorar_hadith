import 'dart:async';

import 'package:http/http.dart' as http;

import 'asset_loader_base.dart';

AssetLoaderBuilder createDefaultAssetLoaderBuilder() {
  return () => WebAssetLoader();
}

/// Asset loader implementation for web environments.
///
/// Fetches assets using HTTP relative to [Uri.base].
/// Shares one [http.Client] for the loader lifetime; call [close] when done
/// (see [DorarClient.dispose]).
class WebAssetLoader implements ClosableAssetLoader {
  final http.Client _client;
  final bool _ownsClient;
  final Uri _baseUri;

  /// Creates a web asset loader.
  ///
  /// When [client] is omitted, this loader owns the [http.Client] and closes
  /// it in [close]. Injected clients are left open for the caller to manage.
  WebAssetLoader({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _ownsClient = client == null,
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

  @override
  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }

  Uri _resolve(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Uri.parse(path);
    }
    return _baseUri.resolve(path);
  }
}
