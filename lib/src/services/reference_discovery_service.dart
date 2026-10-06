import 'dart:convert';

import '../http/cached_transport.dart';
import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../http/query_serializer.dart';
import '../models/api_response.dart';
import '../models/discovery.dart';
import '../models/identifiers.dart';
import '../models/result_details.dart';
import '../models/search_metadata.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';
import 'cache_service.dart';

/// Explicit online discovery. Offline lookups never call these endpoints.
class ReferenceDiscoveryService {
  ReferenceDiscoveryService({
    required DorarHttpClient client,
    required CacheService cache,
    CachedDorarTransport? transport,
  }) : _transport =
           transport ?? CachedDorarTransport(client: client, cache: cache);
  final CachedDorarTransport _transport;

  /// Books associated with the selected scholars' assessments, not authorship.
  Future<ApiResponse<List<ReferenceChoice>>> getBooksForScholars(
    List<ScholarId> scholars,
  ) async {
    if (scholars.isEmpty) {
      throw const DorarValidationException(
        'Select at least one scholar',
        field: 'scholars',
      );
    }
    final ids = scholars.map((s) => s.value).toSet().toList()..sort();
    final url = QuerySerializer.buildUrl(
      '${DorarEndpoints.siteUrl}/hadith/sources-by-mohadith',
      {'m': ids},
    );
    return _choices(
      url,
      'scholarBooks',
      'id',
      'title',
      ReferenceCoverage.currentSelection,
      selectedScholarIds: ids,
    );
  }

  /// Observed narrator filter choices. Autocomplete is partial, not a person list.
  Future<ApiResponse<List<ReferenceChoice>>> searchNarratorChoices(
    String query,
  ) async {
    Validators.validateSearchText(query);
    return _choices(
      QuerySerializer.buildUrl('${DorarEndpoints.siteUrl}/hadith/rawi', {
        'rawi': query,
      }),
      'narratorChoices',
      'value',
      'text',
      ReferenceCoverage.partial,
    );
  }

  Future<ApiResponse<List<ReferenceChoice>>> _choices(
    String url,
    String endpoint,
    String idKey,
    String nameKey,
    ReferenceCoverage coverage, {
    List<String> selectedScholarIds = const [],
  }) async {
    final source = await _transport.get(
      url,
      endpoint: endpoint,
      accepts: (body) {
        try {
          return jsonDecode(body) is List;
        } on FormatException {
          return false;
        }
      },
    );
    final list = jsonDecode(source.body) as List;
    final choices = <ReferenceChoice>[];
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      if (item is! Map || item[idKey] == null || item[nameKey] is! String) {
        throw DorarParseException(
          'Invalid $endpoint choice',
          details: {'index': i},
        );
      }
      choices.add(
        ReferenceChoice(
          id: item[idKey].toString(),
          name: item[nameKey] as String,
        ),
      );
    }
    return ApiResponse(
      data: List.unmodifiable(choices),
      metadata: SearchMetadata(
        length: choices.length,
        referenceCoverage: coverage,
        selectedScholarIds: selectedScholarIds,
        provenance: source.provenance,
        isCached: source.provenance.isCached,
      ),
    );
  }
}
