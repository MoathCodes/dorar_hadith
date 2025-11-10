/// API endpoints and URL builders for Dorar.net
class DorarEndpoints {
  /// Base URL for Dorar.net
  static const String baseUrl = 'https://dorar.net';

  /// Base URL for Dorar.net website
  static const String siteUrl = 'https://www.dorar.net';

  DorarEndpoints._();

  // ============================================================================
  // Hadith Endpoints
  // ============================================================================

  /// Get alternate sahih hadith by ID
  static String alternateHadith(String hadithId) {
    return '$siteUrl/h/$hadithId?alts=1';
  }

  /// Get book information by ID (JSON response with HTML inside)
  ///
  /// Returns JSON: `{"html": "<h5>Book Name</h5><span>Author</span>..."}`
  static String bookById(String bookId) {
    return '$siteUrl/hadith/book-card/$bookId';
  }

  /// Build query parameters map from search params
  ///
  /// Converts Dart model query params to URL-compatible format:
  /// - `value` → `skey` for API endpoints
  /// - `value` → `q` for site endpoints
  /// - Converts enums to their query param values
  static Map<String, dynamic> buildQueryParams(
    Map<String, dynamic> params, {
    bool isApiEndpoint = false,
  }) {
    final result = <String, dynamic>{};

    params.forEach((key, value) {
      if (value == null) return;

      // Convert 'value' to 'skey' for API or 'q' for site
      if (key == 'value') {
        result[isApiEndpoint ? 'skey' : 'q'] = value;
      } else {
        result[key] = value;
      }
    });

    return result;
  }

  /// Get single hadith by ID
  static String hadithById(String hadithId) {
    return '$siteUrl/h/$hadithId';
  }

  /// API endpoint for hadith search (returns JSON)
  ///
  /// Query parameters (all same for API and Site except search text):
  /// - `skey`: Search text (API endpoint only)
  /// - `q`: Search text (Site endpoint only)
  /// - `page`: Page number
  /// - `st`: Search method (0=all, 1=any, 2=exact)
  /// - `d[]`: Hadith degree filters (array)
  /// - `t[]`: Hadith type filters (array) - qudsi, athar, marfoo, sharh
  /// - `rawi[]`: Rawi IDs (array)
  /// - `m[]`: Mohdith IDs (array)
  /// - `s[]`: Book IDs (array)
  static String hadithSearchApi(Map<String, dynamic> params) {
    final queryString = _serializeQueryParams(params);
    return '$baseUrl/dorar_api.json?$queryString';
  }

  // ============================================================================
  // Data Endpoints (Static reference data)
  // ============================================================================
  // Note: These endpoints are from the Node.js API wrapper, NOT dorar.net directly.
  // The Dart package uses local assets instead for offline access.

  /// Site endpoint for hadith search (returns HTML)
  ///
  /// Query parameters (all same for API and Site except search text):
  /// - `q`: Search text (Site endpoint only)
  /// - `skey`: Search text (API endpoint only)
  /// - `page`: Page number
  /// - `st`: Search method
  /// - `d[]`: Hadith degree filters
  /// - `t[]`: Hadith type filters (qudsi, athar, marfoo, sharh)
  /// - `rawi[]`: Rawi IDs
  /// - `m[]`: Mohdith IDs
  /// - `s[]`: Book IDs
  /// - `all`: Include specialist results (optional)
  static String hadithSearchSite(
    Map<String, dynamic> params, {
    bool specialist = false,
  }) {
    final queryString = _serializeQueryParams(params);
    final specialistParam = specialist ? '&all' : '';
    return '$siteUrl/hadith/search?$queryString$specialistParam';
  }

  /// Get mohdith (scholar) information by ID
  ///
  /// Returns HTML page with scholar information
  static String mohdithById(String mohdithId) {
    return '$siteUrl/hadith/mhd/$mohdithId';
  }

  /// Get sharh (explanation) by ID
  static String sharhById(String sharhId) {
    return '$siteUrl/hadith/sharh/$sharhId';
  }

  /// Search for sharh by hadith text
  ///
  /// This searches for hadiths and returns their sharh if available
  static String sharhByText(String text, {bool specialist = false}) {
    final encodedText = Uri.encodeComponent(text);
    final specialistParam = specialist ? '&all' : '';
    return '$siteUrl/hadith/search?q=$encodedText$specialistParam';
  }

  /// Search for all sharh (similar to hadith search but focused on sharh)
  static String sharhSearch(
    Map<String, dynamic> params, {
    bool specialist = false,
  }) {
    return hadithSearchSite(params, specialist: specialist);
  }

  /// Get similar hadiths by ID
  static String similarHadith(String hadithId) {
    return '$siteUrl/h/$hadithId?sims=1';
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Get usul (source chains) hadith by ID
  static String usulHadith(String hadithId) {
    return '$siteUrl/h/$hadithId?osoul=1';
  }

  /// Serialize query parameters to URL query string
  ///
  /// Handles arrays by appending `[]` to the key name:
  /// - `{'rawi': [1, 2]}` becomes `rawi[]=1&rawi[]=2`
  /// - `{'page': 1, 'q': 'test'}` becomes `page=1&q=test`
  ///
  /// This matches the Node.js implementation in `serializeQueryParams.js`
  static String _serializeQueryParams(Map<String, dynamic> params) {
    final buffer = StringBuffer();
    var isFirst = true;

    params.forEach((key, value) {
      if (value == null) return;

      if (!isFirst) buffer.write('&');
      isFirst = false;

      if (value is List) {
        // Handle array parameters
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
