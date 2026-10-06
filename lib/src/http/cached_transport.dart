import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/cache_entry.dart';
import '../models/result_details.dart';
import '../services/cache_service.dart';
import '../utils/exceptions.dart';
import 'http_client.dart';

/// Cache raw source once; model decoding and output formatting stay local.
class CachedDorarTransport {
  CachedDorarTransport({required this.client, required this.cache});
  final DorarHttpClient client;
  final CacheStore cache;
  Future<SourceResponse> get(
    String url, {
    required String endpoint,
    required bool Function(String) accepts,
    Type? expectedType,
    Map<String, String>? headers,
    Duration ttl = const Duration(days: 7),
  }) async {
    final vary = headers == null || headers.isEmpty
        ? ''
        : ':${sha256.convert(utf8.encode(jsonEncode((headers.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((e) => [e.key.toLowerCase(), e.value]).toList())))}';
    final key = 'raw:$endpoint:$url$vary';
    final cached = await cache.get(key);
    if (cached != null) {
      try {
        final envelope = jsonDecode(cached.body) as Map<String, dynamic>;
        final body = envelope['body'] as String;
        if (envelope['version'] == 3 &&
            envelope['endpoint'] == endpoint &&
            envelope['status'] == 200 &&
            envelope['sha256'] ==
                sha256.convert(utf8.encode(body)).toString() &&
            accepts(body)) {
          return SourceResponse(
            body,
            ResultProvenance(
              sourceUri: Uri.parse(url),
              endpoint: endpoint,
              fetchedAt: DateTime.parse(envelope['fetchedAt'] as String),
              isCached: true,
              finalUri: envelope['finalUri'] == null
                  ? null
                  : Uri.parse(envelope['finalUri'] as String),
              contentType: envelope['contentType'] as String?,
              encoding: envelope['encoding'] as String?,
              statusCode: 200,
              contentHash: envelope['sha256'] as String,
            ),
          );
        }
      } on Object {
        /* Corrupt cached source is a miss, never another model. */
      }
      await cache.remove(key);
    }
    final response = await client.getResponse(url, headers: headers);
    final body = response.body;
    if (!accepts(body)) {
      throw DorarParseException(
        'Failed to parse $endpoint: unrecognized response structure',
        expectedType: expectedType,
        details: {'uri': url, 'stage': 'envelope'},
      );
    }
    final now = response.fetchedAt;
    final hash = sha256.convert(utf8.encode(body)).toString();
    await cache.set(
      CacheEntry(
        key: key,
        body: jsonEncode({
          'version': 3,
          'endpoint': endpoint,
          'status': response.statusCode,
          'body': body,
          'sha256': hash,
          'fetchedAt': now.toIso8601String(),
          'finalUri': response.finalUri?.toString(),
          'contentType': response.contentType,
          'encoding': response.encoding,
        }),
        header: '',
        createdAt: now,
        expiresAt: now.add(ttl),
      ),
    );
    return SourceResponse(
      body,
      ResultProvenance(
        sourceUri: Uri.parse(url),
        endpoint: endpoint,
        fetchedAt: now,
        finalUri: response.finalUri,
        contentType: response.contentType,
        encoding: response.encoding,
        statusCode: response.statusCode,
        contentHash: hash,
      ),
    );
  }
}

class SourceResponse {
  const SourceResponse(this.body, this.provenance);
  final String body;
  final ResultProvenance provenance;
}
