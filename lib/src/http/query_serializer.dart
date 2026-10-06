import '../models/search_params.dart';
import '../constants/search_zone.dart';
import '../constants/hadith_type_filter.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';

/// Utilities for serializing search parameters to API query format
class QuerySerializer {
  QuerySerializer._();

  /// Build complete URL with query string
  ///
  /// Example:
  /// ```dart
  /// final url = QuerySerializer.buildUrl(
  ///   'https://dorar.net/hadith/search',
  ///   {'q': 'الصلاة', 'page': 1},
  /// );
  /// // Returns: https://dorar.net/hadith/search?q=%D8%A7%D9%84%D8%B5%D9%84%D8%A7%D8%A9&page=1
  /// ```
  static String buildUrl(String baseUrl, Map<String, dynamic> params) {
    if (params.isEmpty) return baseUrl;
    final queryString = toQueryString(params);
    return '$baseUrl?$queryString';
  }

  /// Convert HadithSearchParams to API query parameters
  ///
  /// For API endpoint (`/dorar_api.json`):
  /// - Uses `skey` for search text
  ///
  /// For site endpoint (`/hadith/search`):
  /// - Uses `q` for search text
  ///
  /// Type scopes are repeated arrays on the site and scalar on the quick API.
  static Map<String, dynamic> serializeHadithParams(
    HadithSearchParams params, {
    bool isApiEndpoint = false,
  }) {
    Validators.validatePage(params.page);
    if ((params.mohdith?.isNotEmpty ?? false) && params.scholarIds.isNotEmpty ||
        (params.books?.isNotEmpty ?? false) && params.bookIds.isNotEmpty ||
        (params.rawi?.isNotEmpty ?? false) &&
            params.narratorChoiceIds.isNotEmpty) {
      throw const DorarValidationException(
        'Provide either typed IDs or legacy references for each filter',
        field: 'filters',
      );
    }
    if (params.optionalPhrases.length > 4) {
      throw const DorarValidationException(
        'At most four optional phrase slots are supported',
        field: 'optionalPhrases',
      );
    }
    if (params.value.trim().isEmpty &&
        (isApiEndpoint ||
            !params.optionalPhrases.any((p) => p.trim().isNotEmpty))) {
      Validators.validateSearchText(params.value);
    } else if (params.value.trim().isNotEmpty) {
      Validators.validateSearchText(params.value);
    }
    for (final phrase in params.optionalPhrases.where(
      (p) => p.trim().isNotEmpty,
    )) {
      Validators.validateSearchText(phrase, field: 'optionalPhrases');
    }
    if (params.zone != null && params.types.isNotEmpty) {
      throw const DorarValidationException(
        'Provide types or legacy zone, not both',
        field: 'types',
      );
    }
    if (params.zone == SearchZone.sharh) {
      throw const DorarValidationException(
        'Use searchSharhText to search explanation prose',
        field: 'zone',
      );
    }
    final types = params.types.isNotEmpty
        ? params.types
        : switch (params.zone) {
            SearchZone.marfoo => {HadithTypeFilter.marfoo},
            SearchZone.qudsi => {HadithTypeFilter.qudsi},
            SearchZone.sahabaAthar => {HadithTypeFilter.companionAthar},
            _ => <HadithTypeFilter>{},
          };
    if (isApiEndpoint &&
        (params.specialist ||
            params.sort != null ||
            params.optionalPhrases.isNotEmpty ||
            types.length > 1 ||
            types.contains(HadithTypeFilter.withExplanation))) {
      throw const DorarValidationException(
        'These filters require the detailed site endpoint',
        field: 'filters',
      );
    }
    if (isApiEndpoint &&
        (types.contains(HadithTypeFilter.marfoo) ||
            (params.rawi?.isNotEmpty ?? false) ||
            params.narratorChoiceIds.isNotEmpty)) {
      throw const DorarValidationException(
        'Marfoo scope and narrator-choice IDs are not verified on the quick API; use detailed site search',
        field: 'filters',
      );
    }
    final queryParams = <String, dynamic>{};

    // Endpoint-specific search text
    if (params.value.isNotEmpty) {
      queryParams[isApiEndpoint ? 'skey' : 'q'] = params.value;
    }

    // Page number - same for both
    queryParams['page'] = params.page;

    // Exclude words - same for both
    if (params.exclude != null && params.exclude!.isNotEmpty) {
      queryParams['xclude'] = params.exclude;
    }

    // Search method - same for both
    if (params.searchMethod != null) {
      queryParams['st'] = params.searchMethod!.id;
    }

    if (types.isNotEmpty) {
      final ids = types.map((t) => t.id).toList()..sort();
      queryParams['t'] = isApiEndpoint ? ids.single : ids;
    }
    if (!isApiEndpoint) {
      if (params.sort != null) queryParams['sort'] = params.sort!.name;
      for (var i = 0; i < params.optionalPhrases.length; i++) {
        if (params.optionalPhrases[i].trim().isNotEmpty) {
          queryParams['optional_phrase${i + 1}'] = params.optionalPhrases[i];
        }
      }
    }

    // Hadith degrees - same for both (NOT 'rad'!)
    if (params.degrees != null && params.degrees!.isNotEmpty) {
      queryParams['d'] = (params.degrees!.map((d) => d.id).toSet().toList()
        ..sort());
    }

    // Mohdith IDs - same for both (NOT 'tr'!)
    if (params.mohdith != null && params.mohdith!.isNotEmpty) {
      queryParams['m'] = (params.mohdith!.map((m) => m.id).toSet().toList()
        ..sort());
    }

    // Book IDs - same for both (NOT 'mhd'!)
    if (params.books != null && params.books!.isNotEmpty) {
      queryParams['s'] = (params.books!.map((b) => b.id).toSet().toList()
        ..sort());
    }

    // Rawi IDs - same for both
    if (params.rawi != null && params.rawi!.isNotEmpty) {
      queryParams['rawi'] = (params.rawi!.map((r) => r.id).toSet().toList()
        ..sort());
    }

    if (params.scholarIds.isNotEmpty) {
      queryParams['m'] =
          params.scholarIds.map((id) => id.value).toSet().toList()..sort();
    }
    if (params.bookIds.isNotEmpty) {
      queryParams['s'] = params.bookIds.map((id) => id.value).toSet().toList()
        ..sort();
    }
    if (params.narratorChoiceIds.isNotEmpty) {
      queryParams['rawi'] =
          params.narratorChoiceIds.map((id) => id.value).toSet().toList()
            ..sort();
    }

    // Note: removeHTML is NOT sent in the serialized query map. The specialist
    // tab flag is applied separately as `&all` on the site URL by
    // [DorarEndpoints], not as a query parameter (matching the Node.js
    // middleware which strips these from req.query before forwarding).

    return queryParams;
  }

  /// Serialize query parameters to URL query string
  ///
  /// Handles arrays by appending `[]` to the key name:
  /// - `{'rawi': [1, 2]}` becomes `rawi[]=1&rawi[]=2`
  /// - `{'page': 1, 'q': 'test'}` becomes `page=1&q=test`
  ///
  /// This matches the Node.js implementation in `serializeQueryParams.js`
  static String toQueryString(Map<String, dynamic> params) {
    final buffer = StringBuffer();
    var isFirst = true;

    params.forEach((key, value) {
      if (value == null || (value is List && value.isEmpty)) return;

      if (!isFirst) buffer.write('&');
      isFirst = false;

      if (value is List) {
        // Handle array parameters with [] suffix
        final arrayParts = value
            .map(
              (v) =>
                  '${Uri.encodeComponent(key)}[]=${Uri.encodeComponent(v.toString())}',
            )
            .join('&');
        buffer.write(arrayParts);
      } else {
        // Handle single value parameters
        buffer.write(
          '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value.toString())}',
        );
      }
    });

    return buffer.toString();
  }
}
