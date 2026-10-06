import 'dart:convert';

import '../http/cached_transport.dart';
import '../http/endpoints.dart';
import '../http/http_client.dart';
import '../http/query_serializer.dart';
import '../models/api_response.dart';
import '../models/discovery.dart';
import '../models/hadith.dart';
import '../models/identifiers.dart';
import '../models/search_metadata.dart';
import '../parsers/html_helper.dart';
import '../utils/exceptions.dart';
import '../utils/validators.dart';
import 'cache_service.dart';
import 'hadith_service.dart';

class CategoryService {
  CategoryService({
    required DorarHttpClient client,
    required CacheService cache,
    CachedDorarTransport? transport,
  }) : _transport =
           transport ?? CachedDorarTransport(client: client, cache: cache),
       _hadith = HadithService(
         client: client,
         cache: cache,
         transport: transport,
       );
  final CachedDorarTransport _transport;
  final HadithService _hadith;
  Future<ApiResponse<List<ThematicRoot>>> getRoots() async {
    final source = await _transport.get(
      '${DorarEndpoints.siteUrl}/hadith-category',
      endpoint: 'categoryRoots',
      accepts: (body) =>
          HtmlHelper.parseHtml(body).querySelector('select#category') != null,
    );
    final choices = HtmlHelper.parseHtml(source.body)
        .querySelectorAll('select#category option')
        .where(
          (o) =>
              o.attributes['value']?.trim().isNotEmpty == true &&
              o.attributes['value'] != '0',
        )
        .map(
          (o) =>
              ThematicRoot(value: o.attributes['value']!, name: o.text.trim()),
        )
        .toList();
    return ApiResponse(
      data: List.unmodifiable(choices),
      metadata: SearchMetadata(
        length: choices.length,
        isCached: source.provenance.isCached,
        provenance: source.provenance,
      ),
    );
  }

  Future<ApiResponse<List<ThematicCategory>>> search(String query) async {
    Validators.validateSearchText(query);
    final source = await _transport.get(
      QuerySerializer.buildUrl(
        '${DorarEndpoints.siteUrl}/hadith-category/newcats',
        {'cat': query},
      ),
      endpoint: 'categorySearch',
      accepts: (body) =>
          body.trim().isEmpty ||
          HtmlHelper.parseHtml(body)
                  .querySelector('a[href*="/hadith-category/cat/"]') !=
              null,
    );
    final choices = HtmlHelper.parseHtml(source.body)
        .querySelectorAll('a[href*="/hadith-category/cat/"]')
        .map((a) {
          final uri = source.provenance.sourceUri.resolve(
            a.attributes['href']!,
          );
          return ThematicCategory(
            id: uri.pathSegments.last,
            name: a.text.trim(),
            uri: uri,
          );
        })
        .toList();
    return ApiResponse(
      data: List.unmodifiable(choices),
      metadata: SearchMetadata(
        length: choices.length,
        isCached: source.provenance.isCached,
        provenance: source.provenance,
      ),
    );
  }

  Future<ApiResponse<List<ThematicCategory>>> getChildren(
    CategorySelector parent,
  ) async {
    final source = await _transport.get(
      QuerySerializer.buildUrl(
        '${DorarEndpoints.siteUrl}/hadith-category/subcategories',
        {'category': parent.value},
      ),
      endpoint: 'categoryChildren',
      accepts: (body) {
        try {
          final decoded = jsonDecode(body);
          return decoded is Map || (decoded is List && decoded.isEmpty);
        } on FormatException {
          return false;
        }
      },
    );
    final decoded = jsonDecode(source.body);
    final mapping = decoded is List
        ? <String, dynamic>{}
        : decoded as Map<String, dynamic>;
    final choices = <ThematicCategory>[];
    for (final entry in mapping.entries) {
      if (entry.value is! String) {
        throw const DorarParseException('Invalid category name');
      }
      final id = CategoryId(entry.key);
      choices.add(
        ThematicCategory(
          id: id.value,
          name: entry.value as String,
          parentSelector: parent.value,
          uri: Uri.parse(
            '${DorarEndpoints.siteUrl}/hadith-category/cat/${Uri.encodeComponent(id.value)}',
          ),
        ),
      );
    }
    return ApiResponse(
      data: List.unmodifiable(choices),
      metadata: SearchMetadata(
        length: choices.length,
        isCached: source.provenance.isCached,
        provenance: source.provenance,
      ),
    );
  }

  Future<ApiResponse<List<DetailedHadith>>> browse(
    CategoryBrowseParams params,
  ) {
    Validators.validatePage(params.page);
    final url = QuerySerializer.buildUrl(
      '${DorarEndpoints.siteUrl}/hadith-category/cat/${Uri.encodeComponent(params.categoryId.value)}',
      {'page': params.page},
    );
    return _hadith.searchSiteUrl(
      params.specialist ? '$url&all' : url,
      page: params.page,
      specialist: params.specialist,
      removeHtml: params.removeHtml,
      parsePolicy: params.parsePolicy,
      category: true,
    );
  }
}
