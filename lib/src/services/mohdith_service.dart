import 'dart:convert';

import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../models/cache_entry.dart';
import '../models/mohdith.dart';
import '../parsers/mohdith_parser.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';
import 'cache_service.dart';

/// Service for fetching mohdith (hadith scholar) information from Dorar.net.
///
/// Validates inputs (e.g., IDs) and throws [DorarValidationException] on invalid input.
/// Network and server issues are surfaced as [DorarException] subclasses
/// (e.g., timeouts, rate limits, HTTP errors).
class MohdithService {
  final DorarHttpClient _client;
  final CacheService _cache;

  MohdithService({required DorarHttpClient client, required CacheService cache})
    : _client = client,
      _cache = cache;

  /// Clear all cached mohdith data.
  ///
  /// Useful for forcing fresh data retrieval.
  Future<void> clearCache() async {
    await _cache.clear();
  }

  /// Get mohdith information by ID.
  ///
  /// Fetches detailed information about a hadith scholar including their name
  /// and biographical information.
  ///
  /// [mohdithId] - The unique identifier of the mohdith.
  /// [removeHtml] - Whether to strip HTML tags from text fields (default: true).
  ///
  /// Returns a [MohdithInfo] object with the scholar's information.
  ///
  /// Throws [DorarValidationException] if the mohdithId is invalid.
  /// Throws [DorarNotFoundException] if the mohdith is not found.
  /// Throws [DorarParseException] if the response cannot be parsed.
  /// May also throw other [DorarException] subclasses for network/timeouts or server errors.
  ///
  /// Example:
  /// ```dart
  /// final mohdith = await mohdithService.getById('256');
  /// print('${mohdith.name}: ${mohdith.info}');
  /// ```
  Future<MohdithInfo> getById(
    String mohdithId, {
    bool removeHtml = true,
  }) async {
    final validatedId = Validators.validateMohdithId(mohdithId);

    final url = DorarEndpoints.mohdithById(validatedId);

    final cached = await _cache.get(url);
    if (cached != null) {
      return MohdithInfo.fromJson(jsonDecode(cached.body));
    }

    try {
      final html = await _client.getHtml(url);
      final parsedData = MohdithParser.parseMohdithPage(
        html,
        mohdithId,
        removeHtml: removeHtml,
      );

      final mohdithInfo = MohdithInfo(
        name: parsedData.name,
        mohdithId: parsedData.mohdithId,
        info: parsedData.info,
      );

      await _cache.set(
        CacheEntry(
          key: url,
          body: jsonEncode(mohdithInfo.toJson()),
          header: '',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
      );

      return mohdithInfo;
    } on FormatException catch (e) {
      throw DorarParseException(
        'Failed to parse mohdith data: ${e.message}',
        expectedType: MohdithInfo,
      );
    }
  }
}
