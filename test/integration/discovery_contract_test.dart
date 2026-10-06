import 'dart:convert';
import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith/src/services/cache_service.dart';
import 'package:drift/native.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

String source(String name) =>
    jsonDecode(
          File('test/fixtures/upstream/$name.json').readAsStringSync(),
        )['body']
        as String;
void main() {
  late CacheService cache;
  late DorarHttpClient http;
  setUp(() {
    cache = CacheService(database: CacheDatabase(NativeDatabase.memory()));
    http = DorarHttpClient(
      client: MockClient((r) async {
        final uri = r.url;
        String name;
        if (uri.path.endsWith('/sources-by-mohadith')) {
          final ids = uri.queryParametersAll['m[]']!;
          name = ids.length == 2 ? 'scholars_both' : 'scholar_${ids.single}';
        } else if (uri.path.endsWith('/rawi')) {
          name =
              'rawi_${['أبو هريرة', 'عائشة', 'عبدالله بن عمر', 'أنس بن مالك'].indexOf(uri.queryParameters['rawi']!)}';
        } else if (uri.path.endsWith('/subcategories')) {
          expect(uri.queryParameters['category'], 'صلاة ');
          name = 'children_prayer';
        } else if (uri.path.endsWith('/newcats')) {
          name = 'category_search';
        } else {
          name = 'category_roots';
        }
        return createUtf8Response(source(name), 200);
      }),
    );
  });
  tearDown(() async {
    http.dispose();
    await cache.dispose();
  });
  test('two scholar choices and their combined response preserve association context', () async {
    final service = ReferenceDiscoveryService(client: http, cache: cache);
    final a = await service.getBooksForScholars([ScholarId('256')]);
    final b = await service.getBooksForScholars([ScholarId('1420')]);
    final both = await service.getBooksForScholars([
      ScholarId('256'),
      ScholarId('1420'),
      ScholarId('256'),
    ]);
    expect(a.data, hasLength(51));
    expect(b.data, hasLength(84));
    expect(both.data.map((e) => e.id).toSet(), {
      ...a.data.map((e) => e.id),
      ...b.data.map((e) => e.id),
    });
    expect(both.metadata.selectedScholarIds, ['1420', '256']);
    expect(both.metadata.referenceCoverage, ReferenceCoverage.currentSelection);
  });
  test('all four autocomplete queries preserve raw alias choices with partial coverage', () async {
    final service = ReferenceDiscoveryService(client: http, cache: cache);
    for (final query in [
      'أبو هريرة',
      'عائشة',
      'عبدالله بن عمر',
      'أنس بن مالك',
    ]) {
      final result = await service.searchNarratorChoices(query);
      expect(result.data, hasLength(30));
      expect(result.metadata.referenceCoverage, ReferenceCoverage.partial);
      expect(
        result.data.every((r) => r.id.isNotEmpty && r.name.isNotEmpty),
        isTrue,
      );
    }
  });
  test('thematic roots, hierarchy and autocomplete use separate opaque identifiers', () async {
    final service = CategoryService(client: http, cache: cache);
    final roots = await service.getRoots();
    expect(roots.data, hasLength(178));
    final prayer = roots.data.firstWhere((r) => r.value == 'صلاة ');
    expect(prayer.selector.value, 'صلاة ');
    final children = await service.getChildren(prayer.selector);
    expect(children.data, isNotEmpty);
    expect(children.data.every((c) => c.parentSelector == 'صلاة '), isTrue);
    final search = await service.search('الصلاة');
    expect(search.data, isNotEmpty);
    expect(search.data.first.uri.path, startsWith('/hadith-category/cat/'));
    expect(CategoryId('opaque-category'), isNotNull);
    expect(HadithRecordId('2065'), isNot(SharhId('2065')));
  });
}
