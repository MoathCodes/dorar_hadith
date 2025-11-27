import 'dart:convert';

import 'package:html/dom.dart' as dom;

import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../http/query_serializer.dart';
import '../models/api_response.dart';
import '../models/cache_entry.dart';
import '../models/hadith.dart';
import '../models/search_metadata.dart';
import '../models/search_params.dart';
import '../models/sharh_metadata.dart';
import '../models/usul_hadith.dart';
import '../parsers/hadith_parser.dart';
import '../parsers/html_helper.dart';
import '../parsers/usul_hadith_parser.dart';
import '../utils/exceptions.dart';
import '../utils/html_stripper.dart';
import '../utils/validators.dart';
import 'cache_service.dart';

/// Service for searching and retrieving hadiths from Dorar.net.
class HadithService {
  final DorarHttpClient _client;
  final CacheService _cache;

  HadithService({required DorarHttpClient client, required CacheService cache})
    : _client = client,
      _cache = cache;

  /// Clear all cached hadith data.
  Future<void> clearCache() async {
    await _cache.clear();
  }

  /// Get the alternate sahih version of a hadith.
  ///
  /// Validates [hadithId] and throws [DorarValidationException] if invalid.
  /// May throw other [DorarException] subclasses for network/timeouts or server errors.
  ///
  /// [hadithId] - Hadith ID
  /// [removeHtml] - Strip HTML tags (default: true)
  ///
  /// Returns alternate [DetailedHadith] or null if none exists.
  Future<DetailedHadith?> getAlternate(
    String hadithId, {
    bool removeHtml = true,
  }) async {
    final validatedId = Validators.validateHadithId(hadithId);

    final url = DorarEndpoints.alternateHadith(validatedId);

    final cached = await _cache.get(url);
    if (cached != null) {
      return DetailedHadith.fromJson(jsonDecode(cached.body));
    }

    final html = await _client.getHtml(url);
    final doc = HtmlHelper.parseHtml(html);

    final borderElements = doc.querySelectorAll('.border-bottom');

    // The alternate hadith is the second element (index 1)
    if (borderElements.length < 2) {
      return null;
    }

    try {
      final hadith = _parseHadithFromBorderElement(
        borderElements[1],
        removeHtml: removeHtml,
      );

      await _cache.set(
        CacheEntry(
          key: url,
          body: jsonEncode(hadith.toJson()),
          header: '',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 7)),
        ),
      );

      return hadith;
    } catch (e) {
      return null;
    }
  }

  /// Get hadith by ID.
  ///
  /// Validates [hadithId] and throws [DorarValidationException] if invalid.
  /// May throw [DorarServerException] if the response structure is unexpected,
  /// and other [DorarException] subclasses for HTTP or parsing errors.
  ///
  /// [hadithId] - Hadith ID
  /// [removeHtml] - Strip HTML tags (default: true)
  Future<DetailedHadith> getById(
    String hadithId, {
    bool removeHtml = true,
  }) async {
    final validatedId = Validators.validateHadithId(hadithId);

    final url = DorarEndpoints.hadithById(validatedId);

    final cached = await _cache.get(url);
    if (cached != null) {
      return DetailedHadith.fromJson(jsonDecode(cached.body));
    }

    final html = await _client.getHtml(url);
    final doc = HtmlHelper.parseHtml(html);

    final borderElement = doc.querySelector('.border-bottom');
    if (borderElement == null) {
      throw const DorarServerException(
        'Invalid response structure from Dorar',
        statusCode: 502,
      );
    }

    final hadith = _parseHadithFromBorderElement(
      borderElement,
      removeHtml: removeHtml,
    );

    await _cache.set(
      CacheEntry(
        key: url,
        body: jsonEncode(hadith.toJson()),
        header: '',
        createdAt: DateTime.now(),

        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),
    );

    return hadith;
  }

  /// Get similar hadiths.
  ///
  /// Validates [hadithId] and throws [DorarValidationException] if invalid.
  /// May throw other [DorarException] subclasses for network/timeouts or server errors.
  ///
  /// [hadithId] - Hadith ID
  /// [removeHtml] - Strip HTML tags (default: true)
  Future<List<DetailedHadith>> getSimilar(
    String hadithId, {
    bool removeHtml = true,
  }) async {
    final validatedId = Validators.validateHadithId(hadithId);

    final url = DorarEndpoints.similarHadith(validatedId);

    final cached = await _cache.get(url);
    if (cached != null) {
      final List<dynamic> jsonList = jsonDecode(cached.body);
      return jsonList.map((e) => DetailedHadith.fromJson(e)).toList();
    }

    final html = await _client.getHtml(url);
    final doc = HtmlHelper.parseHtml(html);

    final borderElements = doc.querySelectorAll('.border-bottom');
    final hadiths = <DetailedHadith>[];

    for (final borderElement in borderElements) {
      try {
        final hadith = _parseHadithFromBorderElement(
          borderElement,
          removeHtml: removeHtml,
        );
        hadiths.add(hadith);
      } catch (e) {
        continue;
      }
    }

    await _cache.set(
      CacheEntry(
        key: url,
        body: jsonEncode(hadiths.map((e) => e.toJson()).toList()),
        header: '',
        createdAt: DateTime.now(),

        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),
    );

    return hadiths;
  }

  /// Get usul hadith (sources).
  ///
  /// Validates [hadithId] and throws [DorarValidationException] if invalid.
  /// Throws [DorarNotFoundException] when no usul hadith are available.
  /// May also throw other [DorarException] subclasses for network or server errors.
  ///
  /// Returns the main hadith along with all its source chains and narrations.
  ///
  /// [hadithId] - Hadith ID
  /// [removeHtml] - Strip HTML tags (default: true)
  /// Get usul hadith (sources) wrapped in ApiResponse with metadata.
  ///
  /// Metadata:
  /// - isCached: whether response came from cache
  /// - length: always 1 (single hadith object)
  /// - usulSourcesCount: number of usul sources
  Future<ApiResponse<UsulHadith>> getUsul(
    String hadithId, {
    bool removeHtml = true,
  }) async {
    final validatedId = Validators.validateHadithId(hadithId);
    final url = DorarEndpoints.usulHadith(validatedId);

    // If cached, return with isCached = true
    final cached = await _cache.get(url);
    if (cached != null) {
      final response = ApiResponse<UsulHadith>.fromJson(
        jsonDecode(cached.body),
        (json) => UsulHadith.fromJson(json as Map<String, dynamic>),
      );
      return response.copyWith(
        metadata: response.metadata.copyWith(isCached: true),
      );
    }

    // Not cached: fetch and build
    final html = await _client.getHtml(url);
    final doc = HtmlHelper.parseHtml(html);

    final mainBorderElement = doc.querySelector('.border-bottom');
    if (mainBorderElement == null) {
      throw const DorarNotFoundException(
        'No usul hadith found',
        resource: 'usul_hadith',
      );
    }

    final mainHadith = _parseHadithFromBorderElement(
      mainBorderElement,
      removeHtml: removeHtml,
      includeUsulFlag: true,
    );

    final parsedSources = UsulHadithParser.parseUsulSources(doc);
    final sources = parsedSources
        .map(
          (ps) => UsulSource(
            source: ps.source,
            chain: ps.chain,
            hadithText: ps.hadithText,
          ),
        )
        .toList();

    final usul = UsulHadith(
      hadith: mainHadith,
      sources: sources,
      count: sources.length,
    );

    final response = ApiResponse<UsulHadith>(
      data: usul,
      metadata: SearchMetadata(
        length: 1, // single hadith object
        usulSourcesCount: sources.length,
        isCached: false,
      ),
    );

    await _cache.set(
      CacheEntry(
        key: url,
        body: jsonEncode(response.toJson((data) => data.toJson())),
        header: '',
        createdAt: DateTime.now(),

        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),
    );
    return response;
  }

  /// Search hadiths via API endpoint (~15 results, faster).
  ///
  /// Validates [params.value] and [params.page] and throws
  /// [DorarValidationException] on invalid input.
  /// Throws [DorarServerException] if the API response is invalid,
  /// and can throw other [DorarException] subclasses for network/timeouts.
  ///
  /// [params] - Search parameters (text, page, filters, removeHtml)
  ///
  /// Returns [Hadith] entries with only the fields exposed by the
  /// public API. Use [HadithService.searchViaSite] when you need the full
  /// metadata payload.
  Future<ApiResponse<List<Hadith>>> searchViaApi(
    HadithSearchParams params,
  ) async {
    final queryParams = QuerySerializer.serializeHadithParams(
      params,
      isApiEndpoint: true,
    );
    final url = DorarEndpoints.hadithSearchApi(queryParams);

    // Return cached with isCached=true if available
    final cached = await _cache.get(url);
    if (cached != null) {
      final response = ApiResponse<List<Hadith>>.fromJson(
        jsonDecode(cached.body),
        (json) => (json as List<dynamic>)
            .map((e) => Hadith.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return response.copyWith(
        metadata: response.metadata.copyWith(isCached: true),
      );
    }

    // Not cached: fetch and parse
    final response = await _client.get(url);
    final data = jsonDecode(response);

    if (data['ahadith'] == null || data['ahadith']['result'] == null) {
      throw const DorarServerException(
        'Invalid response from Dorar API',
        statusCode: 502,
      );
    }

    final htmlContent = HtmlUtils.decodeHtmlEntities(
      data['ahadith']['result'] as String,
    );
    final doc = HtmlHelper.parseHtml(htmlContent);

    final hadithInfoElements = doc.querySelectorAll('.hadith-info');
    final hadiths = <Hadith>[];

    for (final info in hadithInfoElements) {
      try {
        final hadithElement = info.previousElementSibling;
        if (hadithElement == null) continue;

        final hadithText = params.removeHtml
            ? hadithElement.text.replaceAll(RegExp(r'\d+\s*-'), '').trim()
            : hadithElement.innerHtml.replaceAll(RegExp(r'\d+\s*-'), '').trim();

        // Extract metadata using the info-subtitle pattern
        // The HTML structure can be:
        // 1. <span class="info-subtitle">Label:</span> Value<span ...>
        // 2. <span class="info-subtitle">Label:</span><span>Value</span>
        final infoHtml = info.innerHtml;

        // Helper to extract value after a subtitle
        String extractValue(String label) {
          // Try pattern 1: text directly after subtitle (real API)
          final pattern1 = RegExp(
            '<span class="info-subtitle">$label:</span>\\s*([^<]+)',
          );
          var match = pattern1.firstMatch(infoHtml);
          if (match != null && match.group(1)!.trim().isNotEmpty) {
            return match.group(1)!.trim();
          }

          // Try pattern 2: value in next span with possible nested tags (mock responses)
          // Use non-greedy matching and match until </span>
          final pattern2 = RegExp(
            '<span class="info-subtitle">$label:</span>\\s*<span[^>]*>(.*?)</span>',
            dotAll: true,
          );
          match = pattern2.firstMatch(infoHtml);
          if (match != null) {
            // Extract text content from HTML (handles nested <a> tags)
            final fragment = HtmlHelper.parseFragment(match.group(1)!);
            final text = fragment.text?.trim() ?? '';
            if (text.isNotEmpty) return text;
          }

          return '';
        }

        final rawi = extractValue('الراوي');
        final mohdith = extractValue('المحدث');
        final book = extractValue('المصدر');
        final numberOrPage = extractValue('الصفحة أو الرقم');
        final grade = extractValue('خلاصة حكم المحدث');

        hadiths.add(
          Hadith(
            hadith: hadithText,
            rawi: rawi,
            mohdith: mohdith,
            book: book,
            numberOrPage: numberOrPage,
            grade: grade,
          ),
        );
      } catch (e) {
        // Skip malformed hadiths
        continue;
      }
    }

    if (hadiths.isEmpty) {
      throw const DorarServerException(
        'No hadith found in the response',
        statusCode: 502,
      );
    }

    final result = ApiResponse<List<Hadith>>(
      data: hadiths,
      metadata: SearchMetadata(
        length: hadiths.length,
        page: params.page,
        removeHtml: params.removeHtml,
        isCached: false,
      ),
    );

    await _cache.set(
      CacheEntry(
        key: url,
        body: jsonEncode(
          result.toJson((data) => data.map((e) => e.toJson()).toList()),
        ),
        header: '',
        createdAt: DateTime.now(),

        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),
    );
    return result;
  }

  /// Search hadiths via site endpoint (~30 results with full metadata, slower).
  ///
  /// Validates [params.value] and [params.page] and throws
  /// [DorarValidationException] on invalid input. Can throw other
  /// [DorarException] subclasses for network/timeouts or server errors.
  ///
  /// Provides detailed results including hadith IDs, sharh metadata, and related URLs.
  ///
  /// [params] - Search parameters (text, page, specialist, filters, removeHtml)
  Future<ApiResponse<List<DetailedHadith>>> searchViaSite(
    HadithSearchParams params,
  ) async {
    final queryParams = QuerySerializer.serializeHadithParams(
      params,
      isApiEndpoint: false,
    );
    final url = DorarEndpoints.hadithSearchSite(
      queryParams,
      specialist: params.specialist,
    );

    // Return cached with isCached=true if available
    final cached = await _cache.get(url);
    if (cached != null) {
      final response = ApiResponse<List<DetailedHadith>>.fromJson(
        jsonDecode(cached.body),
        (json) => (json as List<dynamic>)
            .map((e) => DetailedHadith.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return response.copyWith(
        metadata: response.metadata.copyWith(isCached: true),
      );
    }

    // Not cached: fetch and parse
    final html = await _client.getHtml(url);
    final doc = HtmlHelper.parseHtml(html);

    final tabName = params.specialist ? 'specialist' : 'home';
    final tabElement = doc.querySelector('#$tabName');

    if (tabElement == null) {
      throw const DorarServerException(
        'Invalid response structure from Dorar',
        statusCode: 502,
      );
    }

    // Extract result counts
    final numberOfNonSpecialist =
        int.tryParse(
          doc
                  .querySelector('a[aria-controls="home"]')
                  ?.text
                  .replaceAll(RegExp(r'[^\d]'), '') ??
              '0',
        ) ??
        0;

    final numberOfSpecialist =
        int.tryParse(
          doc
                  .querySelector('a[aria-controls="specialist"]')
                  ?.text
                  .replaceAll(RegExp(r'[^\d]'), '') ??
              '0',
        ) ??
        0;

    final borderElements = tabElement.querySelectorAll('.border-bottom');
    final hadiths = <DetailedHadith>[];

    for (final borderElement in borderElements) {
      try {
        final hadith = _parseHadithFromBorderElement(
          borderElement,
          removeHtml: params.removeHtml,
        );
        hadiths.add(hadith);
      } catch (e) {
        // Skip malformed hadiths
        continue;
      }
    }

    final result = ApiResponse<List<DetailedHadith>>(
      data: hadiths,
      metadata: SearchMetadata(
        length: hadiths.length,
        page: params.page,
        removeHtml: params.removeHtml,
        specialist: params.specialist,
        numberOfNonSpecialist: numberOfNonSpecialist,
        numberOfSpecialist: numberOfSpecialist,
        isCached: false,
      ),
    );

    await _cache.set(
      CacheEntry(
        key: url,
        body: jsonEncode(
          result.toJson((data) => data.map((e) => e.toJson()).toList()),
        ),
        header: '',
        createdAt: DateTime.now(),

        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),
    );
    return result;
  }

  /// Internal helper to parse a hadith from a .border-bottom element.
  DetailedHadith _parseHadithFromBorderElement(
    dom.Element borderElement, {
    required bool removeHtml,
    bool includeUsulFlag = false,
  }) {
    // Extract hadith text from first child
    final hadithElement = borderElement.children.isNotEmpty
        ? borderElement.children[0]
        : null;

    if (hadithElement == null) {
      throw const FormatException('Hadith element not found');
    }

    var hadithText = removeHtml
        ? hadithElement.text.replaceAll(RegExp(r'\d+\s*-'), '').trim()
        : hadithElement.innerHtml.replaceAll(RegExp(r'\d+\s*-'), '').trim();

    // For getById, also clean up "- :" patterns
    hadithText = hadithText.replaceAll(RegExp(r'-\s*\:?\s*'), '').trim();

    // Extract metadata from second child
    final infoElement = borderElement.children.length > 1
        ? borderElement.children[1]
        : null;

    if (infoElement == null) {
      throw const FormatException('Info element not found');
    }

    final parsedInfo = HadithParser.parseHadithInfo(infoElement);
    final hadithId = HadithParser.getHadithId(borderElement);
    final similarUrl = HadithParser.getSimilarHadithUrl(borderElement);
    final alternateUrl = HadithParser.getAlternateHadithUrl(borderElement);
    final usulUrl = HadithParser.getUsulHadithUrl(borderElement);

    return DetailedHadith(
      hadith: hadithText,
      rawi: parsedInfo.rawi,
      mohdith: parsedInfo.mohdith,
      mohdithId: parsedInfo.mohdithId,
      book: parsedInfo.book,
      bookId: parsedInfo.bookId,
      numberOrPage: parsedInfo.numberOrPage,
      grade: parsedInfo.grade,
      explainGrade: parsedInfo.explainGrade,
      takhrij: parsedInfo.takhrij,
      hadithId: hadithId,
      hasSimilarHadith: similarUrl != null,
      hasAlternateHadithSahih: alternateUrl != null,
      hasUsulHadith: includeUsulFlag || usulUrl != null,
      similarHadithDorar: similarUrl,
      alternateHadithSahihDorar: alternateUrl,
      usulHadithDorar: usulUrl,
      hasSharhMetadata: parsedInfo.sharhId != null,
      sharhMetadata: parsedInfo.sharhId != null
          ? SharhMetadata(id: parsedInfo.sharhId!, isContainSharh: false)
          : null,
    );
  }
}
