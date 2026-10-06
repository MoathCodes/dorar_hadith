import '../http/cached_transport.dart';
import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../http/query_serializer.dart';
import '../models/api_response.dart';
import '../models/related_content.dart';
import '../models/result_details.dart';
import '../models/search_metadata.dart';
import '../models/search_params.dart';
import '../models/sharh.dart';
import '../models/sharh_metadata.dart';
import '../models/source_content.dart';
import '../parsers/collection_parser.dart';
import '../parsers/document_parser.dart';
import '../parsers/html_helper.dart';
import '../parsers/sharh_parser.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';
import 'cache_service.dart';
import 'hadith_service.dart';

/// Associated explanations and prose snippets have separate response contracts.
class SharhService {
  SharhService({
    required DorarHttpClient client,
    required CacheService cache,
    CachedDorarTransport? transport,
  }) : _cache = cache,
       _transport =
           transport ?? CachedDorarTransport(client: client, cache: cache),
       _hadith = HadithService(
         client: client,
         cache: cache,
         transport: transport,
       );
  final CacheService _cache;
  final CachedDorarTransport _transport;
  final HadithService _hadith;
  Future<void> clearCache() => _cache.clear();
  Future<Sharh> getById(String id, {bool removeHtml = true}) async {
    Validators.validateSharhId(id);
    final source = await _transport.get(
      DorarEndpoints.sharhById(id),
      endpoint: 'sharh',
      expectedType: Sharh,
      ttl: const Duration(days: 30),
      accepts: (body) {
        final doc = HtmlHelper.parseHtml(body);
        return doc.querySelector('.border-bottom article') != null &&
            (doc.querySelector('#sharh-text-content') != null ||
                doc.querySelector('.text-justify')?.nextElementSibling != null);
      },
    );
    try {
      final parsed = SharhParser.parseSharhPage(
        source.body,
        id,
        removeHtml: removeHtml,
        sourceUri: source.provenance.sourceUri,
      );
      return Sharh(
        hadith: parsed.record.copyWith(
          hasSharhMetadata: true,
          provenance: source.provenance,
        ),
        document: parsed.document,
        embeddedHadith: parsed.embeddedHadith,
        provenance: source.provenance,
        sharhMetadata: SharhMetadata(
          id: id,
          isContainSharh: true,
          sharh: parsed.sharh,
        ),
      );
    } on FormatException catch (error) {
      throw DorarParseException(
        'Failed to parse explanation: ${error.message}',
        details: {'id': id},
      );
    }
  }

  /// First associated reference in source order; text does not prove identity.
  Future<Sharh> getByText(
    String text, {
    bool specialist = false,
    bool removeHtml = true,
  }) async {
    Validators.validateSearchText(text, field: 'text');
    final matches = await _hadith.searchViaSite(
      HadithSearchParams(
        value: text,
        specialist: specialist,
        removeHtml: removeHtml,
      ),
    );
    final record = matches.data
        .where((r) => r.explanationReference != null)
        .firstOrNull;
    if (record == null) {
      throw DorarNotFoundException(
        'No sharh found: no explanation reference',
        resource: 'sharh',
      );
    }
    final reference = record.explanationReference!;
    final explanation = await getById(reference.id, removeHtml: removeHtml);
    return explanation.copyWith(
      requestedHadithId: record.hadithId,
      explanationReference: reference,
    );
  }

  /// Full explanations associated with matching hadith records. Repeated
  /// explanation IDs retain their independently observed originating links.
  Future<ApiResponse<List<Sharh>>> search(HadithSearchParams params) async {
    final results = await _hadith.searchViaSite(params);
    final references = results.data
        .where((r) => r.explanationReference != null)
        .toList();
    final explanations = <Sharh>[];
    final warnings = <ParseWarning>[...?results.metadata.diagnostics?.warnings];
    for (var i = 0; i < references.length; i++) {
      final record = references[i];
      final reference = record.explanationReference!;
      try {
        final explanation = await getById(
          reference.id,
          removeHtml: params.removeHtml,
        );
        explanations.add(
          explanation.copyWith(
            requestedHadithId: record.hadithId,
            explanationReference: reference,
          ),
        );
      } on DorarException catch (error) {
        if (params.parsePolicy == ParsePolicy.strict) {
          throw DorarSubrequestException(
            cause: error,
            referenceId: reference.id,
            requestedRecordId: record.hadithId,
          );
        }
        if (warnings.length < 50) {
          warnings.add(
            ParseWarning(
              stage: 'explanationFetch',
              index: i,
              recordId: record.hadithId,
              message: error.message,
            ),
          );
        }
      }
    }
    return ApiResponse(
      data: List.unmodifiable(explanations),
      metadata: results.metadata.copyWith(
        length: explanations.length,
        diagnostics: ParseDiagnostics(
          candidateCount: references.length,
          parsedCount: explanations.length,
          completeness: warnings.isEmpty
              ? ParseCompleteness.complete
              : ParseCompleteness.partial,
          warnings: List.unmodifiable(warnings),
        ),
      ),
    );
  }

  /// Search inside explanation prose. Returned snippets are not full records.
  Future<ApiResponse<List<SharhSnippet>>> searchText(
    SharhTextSearchParams params,
  ) async {
    Validators.validateSearchText(params.value);
    Validators.validatePage(params.page);
    final url = QuerySerializer.buildUrl(
      '${DorarEndpoints.siteUrl}/hadith/search',
      {'q': params.value, 't': 3, 'page': params.page},
    );
    final fragment = params.page > 1;
    final source = await _transport.get(
      url,
      endpoint: 'sharhTextSearch',
      headers: fragment ? {'X-Requested-With': 'XMLHttpRequest'} : null,
      accepts: (body) {
        if (fragment && body.trim().isEmpty) return true;
        final doc = HtmlHelper.parseHtml(body);
        return !body.contains('id="home"') &&
            (fragment
                ? doc.querySelector(
                        'article.border-bottom a[href*="/hadith/sharh/"]',
                      ) !=
                      null
                : (doc.querySelector('#cntnt #results-end') != null ||
                      (doc.querySelector('form#inner-search') != null &&
                          doc
                                  .querySelector('h5 img[alt="no-result"]')
                                  ?.parent
                                  ?.text
                                  .contains('لا توجد نتائج') ==
                              true)));
      },
    );
    final doc = HtmlHelper.parseHtml(source.body);
    final articles = doc.querySelectorAll(
      fragment ? 'article.border-bottom' : '#cntnt article',
    );
    final parsed = parseCollection(
      articles,
      (article, i) {
        final link = article.querySelector('a[href*="/hadith/sharh/"]');
        final href = link?.attributes['href'];
        final uri = href == null
            ? null
            : source.provenance.sourceUri.resolve(href);
        final id = uri == null
            ? null
            : RegExp(r'^/hadith/sharh/(\d+)$').firstMatch(uri.path)?[1];
        if (id == null || link == null) {
          throw const FormatException('Explanation snippet link missing');
        }
        return SharhSnippet(
          id: id,
          uri: uri!,
          document: DocumentParser.parse(
            link.innerHtml,
            sourceUri: source.provenance.sourceUri,
            defaultKind: BlockKind.commentary,
          ),
        );
      },
      policy: params.parsePolicy,
      stage: 'sharhTextSearch',
    );
    final navigation = doc.querySelectorAll('a[href*="page="], a[rel="next"]');
    final next = navigation.any((a) {
      final uri = source.provenance.sourceUri.resolve(
        a.attributes['href'] ?? '',
      );
      return a.attributes['rel'] == 'next' ||
          (int.tryParse(uri.queryParameters['page'] ?? '') ?? 0) > params.page;
    });
    final knownNavigation = navigation.isNotEmpty;
    final nextPage = knownNavigation ? next : parsed.items.length == 15;
    return ApiResponse(
      data: parsed.items,
      metadata: SearchMetadata(
        length: parsed.items.length,
        currentPageCount: parsed.items.length,
        page: params.page,
        hasNextPage: nextPage,
        hasPrevPage: params.page > 1,
        provenance: source.provenance,
        isCached: source.provenance.isCached,
        diagnostics: parsed.diagnostics,
        pagination: PageMetadata(
          page: params.page,
          pageSize: 15,
          hasNextPage: nextPage,
          nextPageEvidence: knownNavigation
              ? NextPageEvidence.upstreamNavigation
              : NextPageEvidence.pageSizeHint,
        ),
      ),
    );
  }
}
