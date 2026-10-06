import 'dart:convert';

import 'package:html/dom.dart' as dom;

import '../http/cached_transport.dart';
import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../http/query_serializer.dart';
import '../models/api_response.dart';
import '../models/hadith.dart';
import '../models/related_content.dart';
import '../models/result_details.dart';
import '../models/search_metadata.dart';
import '../models/search_params.dart';
import '../models/source_content.dart';
import '../models/usul_hadith.dart';
import '../parsers/collection_parser.dart';
import '../parsers/document_parser.dart';
import '../parsers/hadith_parser.dart';
import '../parsers/html_helper.dart';
import '../parsers/record_parser.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';
import 'cache_service.dart';

/// Endpoint-specific search and related records, backed by raw source caching.
class HadithService {
  static const apiPageSize = 15;
  static const sitePageSize = 30;
  static const siteMaxPages = 10;
  final CacheService _cache;
  final CachedDorarTransport _transport;
  HadithService({
    required DorarHttpClient client,
    required CacheService cache,
    CachedDorarTransport? transport,
  }) : _cache = cache,
       _transport =
           transport ?? CachedDorarTransport(client: client, cache: cache);
  Future<void> clearCache() => _cache.clear();

  Future<SourceResponse> _detail(String id, String url) {
    Validators.validateHadithId(id);
    return _transport.get(
      url,
      endpoint: 'record',
      accepts: (body) =>
          HtmlHelper.parseHtml(body)
              .querySelector('.border-bottom article, .border-bottom > div') !=
          null,
    );
  }

  DetailedHadith _record(
    dom.Element block,
    SourceResponse source, {
    bool removeHtml = true,
    String? expectedId,
    HadithTextCleanMode mode = HadithTextCleanMode.detail,
  }) => RecordParser.parse(
    block,
    sourceUri: source.provenance.sourceUri,
    removeHtml: removeHtml,
    expectedId: expectedId,
    mode: mode,
  ).copyWith(provenance: source.provenance);

  Future<DetailedHadith> getById(
    String hadithId, {
    bool removeHtml = true,
  }) async {
    final source = await _detail(hadithId, DorarEndpoints.hadithById(hadithId));
    try {
      return _record(
        HtmlHelper.parseHtml(source.body).querySelector('.border-bottom')!,
        source,
        removeHtml: removeHtml,
        expectedId: hadithId,
      );
    } on FormatException catch (e) {
      throw DorarParseException(
        'Invalid hadith record: ${e.message}',
        details: {'id': hadithId},
        cause: e,
      );
    }
  }

  /// Retrieves every authentic alternative in source order, excluding the seed.
  Future<ApiResponse<RelatedHadithResult>> getAlternates(
    String id, {
    bool removeHtml = true,
    ParsePolicy parsePolicy = ParsePolicy.strict,
  }) => _related(id, RelatedHadithKind.alternate, removeHtml, parsePolicy);
  Future<ApiResponse<RelatedHadithResult>> getSimilarResult(
    String id, {
    bool removeHtml = true,
    ParsePolicy parsePolicy = ParsePolicy.strict,
  }) => _related(id, RelatedHadithKind.similar, removeHtml, parsePolicy);
  Future<ApiResponse<RelatedHadithResult>> _related(
    String id,
    RelatedHadithKind kind,
    bool removeHtml,
    ParsePolicy policy,
  ) async {
    final url = kind == RelatedHadithKind.alternate
        ? DorarEndpoints.alternateHadith(id)
        : DorarEndpoints.similarHadith(id);
    final source = await _detail(id, url);
    final blocks = HtmlHelper.parseHtml(source.body)
        .querySelectorAll('.border-bottom');
    final parsed = parseCollection(
      blocks,
      (block, index) => _record(block, source, removeHtml: removeHtml),
      policy: policy,
      stage: 'related',
      recordId: HadithParser.getHadithId,
    );
    final seed = parsed.items.where((r) => r.hadithId == id).firstOrNull;
    if (seed == null && policy == ParsePolicy.strict) {
      throw DorarParseException(
        'Requested seed record not identified',
        details: {'id': id, 'stage': 'seedIdentity'},
      );
    }
    final diagnostics = seed == null
        ? ParseDiagnostics(
            candidateCount: parsed.diagnostics.candidateCount,
            parsedCount: parsed.diagnostics.parsedCount,
            completeness: ParseCompleteness.partial,
            warnings: [
              ...parsed.diagnostics.warnings,
              ParseWarning(
                stage: 'seedIdentity',
                recordId: id,
                message: 'Requested seed could not be resolved; all parsed records retained',
              ),
            ],
          )
        : parsed.diagnostics;
    final related = parsed.items.where((r) => !identical(r, seed)).toList();
    return ApiResponse(
      data: RelatedHadithResult(
        requestedId: id,
        source: seed,
        kind: kind,
        related: List.unmodifiable(related),
      ),
      metadata: SearchMetadata(
        length: related.length,
        isCached: source.provenance.isCached,
        provenance: source.provenance,
        diagnostics: diagnostics,
      ),
    );
  }

  /// Legacy first-alternative convenience. Errors are never converted to null.
  Future<DetailedHadith?> getAlternate(
    String id, {
    bool removeHtml = true,
  }) async => (await getAlternates(
    id,
    removeHtml: removeHtml,
  )).data.related.firstOrNull;

  /// Legacy list preserves seed inclusion. New code uses getSimilarResult.
  Future<List<DetailedHadith>> getSimilar(
    String id, {
    bool removeHtml = true,
  }) async {
    final result = await getSimilarResult(id, removeHtml: removeHtml);
    return [result.data.source!, ...result.data.related];
  }

  Future<ApiResponse<AsbabResult>> getAsbab(
    String id, {
    bool removeHtml = true,
    ParsePolicy parsePolicy = ParsePolicy.strict,
  }) async {
    final source = await _detail(
      id,
      '${DorarEndpoints.hadithById(id)}?asbab=1',
    );
    final doc = HtmlHelper.parseHtml(source.body);
    final blocks = doc.querySelectorAll('.border-bottom');
    final parsed = parseCollection(
      blocks,
      (block, i) => _record(
        block,
        source,
        removeHtml: removeHtml,
        expectedId: i == 0 ? id : null,
      ),
      policy: parsePolicy,
      stage: 'asbab',
      recordId: HadithParser.getHadithId,
    );
    final seed = parsed.items.where((r) => r.hadithId == id).firstOrNull;
    if (seed == null) {
      throw const DorarParseException('Context seed record not identified');
    }
    final heading = doc
        .querySelectorAll('h4, h3')
        .map((e) => e.text)
        .where((t) => t.contains('سبب') || t.contains('أسباب'))
        .join(' ');
    final contexts = parsed.items
        .where((r) => !identical(r, seed))
        .map(
          (r) => AsbabNarration(
            hadith: r,
            document: r.content!,
            rawLabel: heading,
            relationship: RecordParser.relationship(heading),
          ),
        )
        .toList();
    return ApiResponse(
      data: AsbabResult(
        requestedId: id,
        source: seed,
        narrations: List.unmodifiable(contexts),
      ),
      metadata: SearchMetadata(
        length: contexts.length,
        provenance: source.provenance,
        isCached: source.provenance.isCached,
        diagnostics: parsed.diagnostics,
      ),
    );
  }

  Future<ApiResponse<UsulHadith>> getUsul(
    String id, {
    bool removeHtml = true,
    ParsePolicy parsePolicy = ParsePolicy.strict,
  }) async {
    final source = await _detail(id, DorarEndpoints.usulHadith(id));
    final doc = HtmlHelper.parseHtml(source.body);
    late DetailedHadith seed;
    try {
      seed = _record(
        doc.querySelector('.border-bottom')!,
        source,
        removeHtml: removeHtml,
        expectedId: id,
      );
    } on FormatException catch (error) {
      throw DorarParseException(
        'Invalid source-chain seed: ${error.message}',
        cause: error,
        details: {'id': id, 'stage': 'seedIdentity'},
      );
    }
    final articles = doc
        .querySelectorAll('article')
        .where(
          (a) =>
              a.querySelector(
                'span[style*="color:maroon"], span[style*="color: maroon"], span[style*="color:blue"], span[style*="color: blue"]',
              ) !=
              null,
        )
        .toList();
    final parsed = parseCollection(
      articles,
      (article, i) {
        final h5 = article.querySelector('h5');
        if (h5 == null) {
          throw const FormatException('Source narration heading not found');
        }
        final sourceNode = h5.querySelector(
          'span[style*="color:maroon"], span[style*="color: maroon"]',
        );
        final chainNode = h5.querySelector(
          'span[style*="color:blue"], span[style*="color: blue"]',
        );
        final clone = h5.clone(true);
        clone
            .querySelectorAll(
              'span[style*="color:maroon"], span[style*="color: maroon"], span[style*="color:blue"], span[style*="color: blue"]',
            )
            .forEach((e) => e.remove());
        if (sourceNode == null || chainNode == null) {
          throw const FormatException('Source reference or chain missing');
        }
        final chain = DocumentParser.parse(
          chainNode.innerHtml,
          sourceUri: source.provenance.sourceUri,
          defaultKind: BlockKind.chain,
        );
        final narration = DocumentParser.parse(
          clone.innerHtml,
          sourceUri: source.provenance.sourceUri,
          defaultKind: BlockKind.narration,
        );
        return UsulSource(
          source: sourceNode.text.trim(),
          chain: chain.plainText.trim(),
          hadithText: removeHtml ? narration.plainText.trim() : clone.innerHtml,
          citation: Citation(source: sourceNode.text.trim()),
          chainContent: chain,
          narrationContent: narration,
        );
      },
      policy: parsePolicy,
      stage: 'usul',
    );
    return ApiResponse(
      data: UsulHadith(
        hadith: seed,
        sources: parsed.items,
        count: parsed.items.length,
      ),
      metadata: SearchMetadata(
        length: 1,
        usulSourcesCount: parsed.items.length,
        provenance: source.provenance,
        isCached: source.provenance.isCached,
        diagnostics: parsed.diagnostics,
      ),
    );
  }

  Future<ApiResponse<List<Hadith>>> searchViaApi(
    HadithSearchParams params,
  ) async {
    final query = QuerySerializer.serializeHadithParams(
      params,
      isApiEndpoint: true,
    );
    final source = await _transport.get(
      DorarEndpoints.hadithSearchApi(query),
      endpoint: 'quickSearch',
      accepts: _acceptQuick,
    );
    final data = jsonDecode(source.body) as Map<String, dynamic>;
    final doc = HtmlHelper.parseHtml(
      (data['ahadith'] as Map<String, dynamic>)['result'] as String,
    );
    final infos = doc.querySelectorAll('.hadith-info');
    if (infos.isEmpty && !_emptyQuick(doc)) {
      throw const DorarParseException('Unknown empty quick-search layout');
    }
    final parsed = parseCollection(
      infos,
      (info, i) {
        final narration = info.previousElementSibling;
        if (narration == null) {
          throw const FormatException('Quick narration not found');
        }
        final metadata = HadithParser.parseHadithInfo(info);
        final document = DocumentParser.parse(
          narration.innerHtml,
          defaultKind: BlockKind.narration,
          sourceUri: source.provenance.sourceUri,
        );
        if (document.plainText.trim().isEmpty ||
            metadata.rawi.isEmpty ||
            metadata.book.isEmpty) {
          throw const FormatException('Incomplete quick-search record');
        }
        return Hadith(
          hadith: params.removeHtml
              ? HadithParser.cleanHadithText(
                  document.plainText,
                  HadithTextCleanMode.search,
                )
              : narration.innerHtml,
          rawi: metadata.rawi,
          mohdith: metadata.mohdith,
          book: metadata.book,
          numberOrPage: metadata.numberOrPage,
          grade: metadata.grade,
        );
      },
      policy: params.parsePolicy,
      stage: 'quickSearch',
    );
    final next = parsed.items.length == apiPageSize;
    return ApiResponse(
      data: parsed.items,
      metadata: SearchMetadata(
        length: parsed.items.length,
        currentPageCount: parsed.items.length,
        page: params.page,
        hasNextPage: next,
        hasPrevPage: params.page > 1,
        removeHtml: params.removeHtml,
        isCached: source.provenance.isCached,
        provenance: source.provenance,
        diagnostics: parsed.diagnostics,
        pagination: PageMetadata(
          page: params.page,
          pageSize: apiPageSize,
          hasNextPage: next,
          nextPageEvidence: NextPageEvidence.pageSizeHint,
        ),
      ),
    );
  }

  static bool _emptyQuick(dom.Document doc) =>
      doc.querySelector('link[rel="canonical"][href*="dorar_api.json"]') !=
          null &&
      doc.querySelector('a[href*="/hadith/search"]') != null;
  static bool _acceptQuick(String body) {
    try {
      final json = jsonDecode(body);
      if (json is! Map ||
          json['ahadith'] is! Map ||
          json['ahadith']['result'] is! String) {
        return false;
      }
      final doc = HtmlHelper.parseHtml(json['ahadith']['result'] as String);
      return doc.querySelector('.hadith-info') != null || _emptyQuick(doc);
    } on FormatException {
      return false;
    }
  }

  Future<ApiResponse<List<DetailedHadith>>> searchViaSite(
    HadithSearchParams params,
  ) async {
    final query = QuerySerializer.serializeHadithParams(params);
    if (params.page > siteMaxPages) {
      throw const DorarValidationException(
        'Ordinary search serves at most ten pages; thematic browsing has its own limits',
        field: 'page',
      );
    }
    return searchSiteUrl(
      DorarEndpoints.hadithSearchSite(query, specialist: params.specialist),
      page: params.page,
      specialist: params.specialist,
      removeHtml: params.removeHtml,
      parsePolicy: params.parsePolicy,
    );
  }

  /// Shared scoped tab parsing for ordinary search and thematic browsing.
  Future<ApiResponse<List<DetailedHadith>>> searchSiteUrl(
    String url, {
    required int page,
    bool specialist = false,
    bool removeHtml = true,
    ParsePolicy parsePolicy = ParsePolicy.strict,
    bool category = false,
  }) async {
    final tab = specialist ? 'specialist' : 'home';
    final source = await _transport.get(
      url,
      endpoint: category ? 'categoryBrowse' : 'siteSearch',
      accepts: (body) =>
          HtmlHelper.parseHtml(body).querySelector('#$tab') != null,
    );
    final doc = HtmlHelper.parseHtml(source.body);
    final candidates = doc
        .querySelector('#$tab')!
        .querySelectorAll('.border-bottom');
    final parsed = parseCollection(
      candidates,
      (block, i) => _record(
        block,
        source,
        removeHtml: removeHtml,
        mode: HadithTextCleanMode.search,
      ),
      policy: parsePolicy,
      stage: category ? 'categoryBrowse' : 'siteSearch',
      recordId: HadithParser.getHadithId,
    );
    int? count(String name) {
      final label = doc.querySelector('a[aria-controls="$name"]')?.text;
      if (label == null) return null;
      return int.tryParse(label.replaceAll(RegExp(r'[^0-9]'), ''));
    }

    final home = count('home'), special = count('specialist');
    final total = specialist ? special : home;
    final size = category ? 20 : sitePageSize;
    final displayedPages = total == null ? null : (total / size).ceil();
    final accessible = category
        ? displayedPages
        : displayedPages?.clamp(0, siteMaxPages);
    final next = accessible == null ? null : page < accessible;
    return ApiResponse(
      data: parsed.items,
      metadata: SearchMetadata(
        length: parsed.items.length,
        currentPageCount: parsed.items.length,
        page: page,
        total: total,
        totalPages: accessible,
        hasNextPage: next,
        hasPrevPage: page > 1,
        specialist: specialist,
        removeHtml: removeHtml,
        numberOfNonSpecialist: home,
        numberOfSpecialist: special,
        provenance: source.provenance,
        isCached: source.provenance.isCached,
        diagnostics: parsed.diagnostics,
        pagination: PageMetadata(
          page: page,
          pageSize: size,
          displayedTotal: total,
          displayedTotalPages: displayedPages,
          accessiblePageLimit: category ? null : siteMaxPages,
          reachableTotalUpperBound: category
              ? total
              : total?.clamp(0, sitePageSize * siteMaxPages),
          truncated: category
              ? false
              : total == null
              ? null
              : total > sitePageSize * siteMaxPages,
          hasNextPage: next,
          nextPageEvidence: category
              ? NextPageEvidence.upstreamNavigation
              : NextPageEvidence.knownLimit,
        ),
      ),
    );
  }
}
