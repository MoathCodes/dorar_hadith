import '../models/search_params.dart';

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
  /// All other parameters use the SAME keys for both endpoints.
  static Map<String, dynamic> serializeHadithParams(
    HadithSearchParams params, {
    bool isApiEndpoint = false,
  }) {
    final queryParams = <String, dynamic>{};

    // Search text - ONLY difference between API and Site
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

    // Search zone - same for both (NOT 'grp'!)
    if (params.zone != null) {
      queryParams['t'] = params.zone!.id;
    }

    // Hadith degrees - same for both (NOT 'rad'!)
    if (params.degrees != null && params.degrees!.isNotEmpty) {
      queryParams['d'] = params.degrees!.map((d) => d.id).toList();
    }

    // Mohdith IDs - same for both (NOT 'tr'!)
    if (params.mohdith != null && params.mohdith!.isNotEmpty) {
      queryParams['m'] = params.mohdith!.map((m) => m.id).toList();
    }

    // Book IDs - same for both (NOT 'mhd'!)
    if (params.books != null && params.books!.isNotEmpty) {
      queryParams['s'] = params.books!.map((b) => b.id).toList();
    }

    // Rawi IDs - same for both
    if (params.rawi != null && params.rawi!.isNotEmpty) {
      queryParams['rawi'] = params.rawi!.map((r) => r.id).toList();
    }
    // Remove HTML flag - same for both
    queryParams['removeHTML'] = params.removeHtml ? '1' : '0';

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
      if (value == null) return;

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
