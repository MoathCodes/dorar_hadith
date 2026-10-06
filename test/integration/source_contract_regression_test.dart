import 'dart:convert';
import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith/src/services/cache_service.dart';
import 'package:dorar_hadith/src/models/cache_entry.dart';
import 'package:dorar_hadith/src/parsers/sharh_parser.dart';
import 'package:drift/native.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../fixtures/mock_responses.dart';
import '../helpers/test_helpers.dart';

String source(String name) =>
    (jsonDecode(File('test/fixtures/upstream/$name.json').readAsStringSync())
            as Map<String, dynamic>)['body']
        as String;
void main() {
  test(
    'all 24 explanation documents retain structure without assigning speakers',
    () {
      final files = Directory('test/fixtures/upstream')
          .listSync()
          .whereType<File>()
          .where((f) => f.uri.pathSegments.last.startsWith('sharh_'))
          .toList();
      expect(files, hasLength(24));
      var embedded = 0;
      for (final file in files) {
        final id = file.uri.pathSegments.last
            .replaceFirst('sharh_', '')
            .replaceFirst('.json', '');
        final parsed = SharhParser.parseSharhPage(
          jsonDecode(file.readAsStringSync())['body'] as String,
          id,
        );
        expect(parsed.grade, isNotEmpty, reason: id);
        expect(parsed.document.sourceText, isNotEmpty);
        final tokens = documentRenderTokens(parsed.document);
        expect(tokens.every((t) => t.attribution == null), isTrue, reason: id);
        for (final token in tokens) {
          expect(token.range.extract(parsed.document.sourceText), token.text);
        }
        if (parsed.embeddedHadith != null) embedded++;
        expect(
          Sharh.fromJson(
            Sharh(
              hadith: parsed.record,
              document: parsed.document,
              embeddedHadith: parsed.embeddedHadith,
            ).toJson(),
          ).document,
          parsed.document,
        );
      }
      expect(embedded, greaterThan(0));
    },
  );
  test(
    'unresolved related seed is rejected strictly and retained in best effort',
    () async {
      final cache = CacheService(
        database: CacheDatabase(NativeDatabase.memory()),
      );
      addTearDown(cache.dispose);
      final http = DorarHttpClient(
        client: MockClient(
          (r) async => createUtf8Response(
            mockAlternateHadithResponse.replaceFirst(
              'tag="123"',
              'tag="different"',
            ),
            200,
          ),
        ),
      );
      addTearDown(http.dispose);
      final service = HadithService(client: http, cache: cache);
      await expectLater(
        service.getAlternates('123'),
        throwsA(isA<DorarParseException>()),
      );
      final partial = await service.getAlternates(
        '123',
        parsePolicy: ParsePolicy.bestEffort,
      );
      expect(partial.data.source, isNull);
      expect(partial.data.related, hasLength(2));
      expect(
        partial.metadata.diagnostics!.completeness,
        ParseCompleteness.partial,
      );
      expect(partial.metadata.diagnostics!.warnings.last.stage, 'seedIdentity');
    },
  );

  test(
    'detail and source-chain endpoints reject an observed different seed ID',
    () async {
      final cache = CacheService(
        database: CacheDatabase(NativeDatabase.memory()),
      );
      addTearDown(cache.dispose);
      final http = DorarHttpClient(
        client: MockClient(
          (r) async => createUtf8Response(
            mockAlternateHadithResponse.replaceFirst(
              'tag="123"',
              'tag="different"',
            ),
            200,
          ),
        ),
      );
      addTearDown(http.dispose);
      final service = HadithService(client: http, cache: cache);
      await expectLater(
        service.getById('123'),
        throwsA(
          isA<DorarParseException>().having(
            (e) => e.cause,
            'original error',
            isA<FormatException>(),
          ),
        ),
      );
      await expectLater(
        service.getUsul('123'),
        throwsA(
          isA<DorarParseException>().having(
            (e) => e.cause,
            'original error',
            isA<FormatException>(),
          ),
        ),
      );
    },
  );
  test('associated explanation failures retain transport cause and originating identity', () async {
    final cache = CacheService(
      database: CacheDatabase(NativeDatabase.memory()),
    );
    addTearDown(cache.dispose);
    final http = DorarHttpClient(
      client: MockClient(
        (r) async => createUtf8Response(
          r.url.path.endsWith('/search')
              ? mockHadithSearchSiteResponse
              : 'missing',
          r.url.path.endsWith('/search') ? 200 : 404,
        ),
      ),
    );
    addTearDown(http.dispose);
    final service = SharhService(client: http, cache: cache);
    await expectLater(
      service.search(const HadithSearchParams(value: 'الصلاة')),
      throwsA(
        isA<DorarSubrequestException>()
            .having((e) => e.referenceId, 'observed explanation', '456')
            .having((e) => e.requestedRecordId, 'origin', '123')
            .having(
              (e) => e.cause,
              'original transport category',
              isA<DorarNotFoundException>(),
            ),
      ),
    );
    final partial = await service.search(
      const HadithSearchParams(
        value: 'الصلاة',
        parsePolicy: ParsePolicy.bestEffort,
      ),
    );
    expect(partial.data, isEmpty);
    expect(
      partial.metadata.diagnostics!.completeness,
      ParseCompleteness.partial,
    );
    expect(partial.metadata.diagnostics!.skippedCount, 1);
    expect(
      partial.metadata.diagnostics!.warnings.single.stage,
      'explanationFetch',
    );
  });
  test(
    'old saved JSON remains readable without manufacturing source structure',
    () {
      final json = {
        'hadith': {
          'hadith': 'نص محفوظ',
          'rawi': 'راو',
          'mohdith': 'محدث',
          'book': 'مصدر',
          'numberOrPage': '1',
          'grade': 'صحيح الإسناد',
        },
        'sharhMetadata': {
          'id': '2065',
          'isContainSharh': true,
          'sharh': 'شرح محفوظ',
        },
      };
      final saved = Sharh.fromJson(json);
      expect(saved.document, isNull);
      expect(saved.hadith.content, isNull);
      expect(saved.grade, 'صحيح الإسناد');
      expect(
        ExplainedHadith.fromJson(json['hadith'] as Map<String, dynamic>)
            .toDetailedHadith()
            .grade,
        saved.grade,
      );
    },
  );
  test('strict and best effort parse the same cached source with accountable failures', () async {
    final cache = CacheService(
      database: CacheDatabase(NativeDatabase.memory()),
    );
    addTearDown(cache.dispose);
    var requests = 0;
    final body = mockHadithSearchSiteResponse.replaceFirst('عمر بن الخطاب', '');
    final http = DorarHttpClient(
      client: MockClient((r) async {
        requests++;
        return createUtf8Response(body, 200);
      }),
    );
    addTearDown(http.dispose);
    final service = HadithService(client: http, cache: cache);
    await expectLater(
      service.searchViaSite(const HadithSearchParams(value: 'اختبار')),
      throwsA(isA<DorarParseException>()),
    );
    final partial = await service.searchViaSite(
      const HadithSearchParams(
        value: 'اختبار',
        parsePolicy: ParsePolicy.bestEffort,
      ),
    );
    expect(requests, 1);
    expect(partial.data, hasLength(1));
    expect(partial.metadata.isCached, isTrue);
    expect(partial.metadata.diagnostics!.candidateCount, 2);
    expect(partial.metadata.diagnostics!.skippedCount, 1);
    expect(partial.metadata.diagnostics!.warnings.single.recordId, '123');
  });
  test('corrupt raw cache is evicted individually and persistent raw hits preserve render mode', () async {
    final dir = await Directory.systemTemp.createTemp('dorar-cache-contract');
    addTearDown(() => dir.delete(recursive: true));
    final database = File('${dir.path}/cache.db');
    var cache = CacheService(database: CacheDatabase(NativeDatabase(database)));
    var requests = 0;
    final http = DorarHttpClient(
      client: MockClient((r) async {
        requests++;
        return createUtf8Response(mockHadithByIdResponse, 200);
      }),
    );
    addTearDown(http.dispose);
    final url = DorarEndpoints.hadithById('123');
    final key = 'raw:record:$url';
    final now = DateTime.now();
    await cache.set(
      CacheEntry(
        key: key,
        body: 'corrupt',
        header: '',
        createdAt: now,
        expiresAt: now.add(const Duration(days: 1)),
      ),
    );
    await cache.set(
      CacheEntry(
        key: 'unrelated',
        body: 'retained',
        header: '',
        createdAt: now,
        expiresAt: now.add(const Duration(days: 1)),
      ),
    );
    final first = await HadithService(
      client: http,
      cache: cache,
    ).getById('123');
    expect(requests, 1);
    expect(await cache.get('unrelated'), isNotNull);
    await cache.dispose();
    cache = CacheService(database: CacheDatabase(NativeDatabase(database)));
    addTearDown(cache.dispose);
    final second = await HadithService(
      client: http,
      cache: cache,
    ).getById('123', removeHtml: false);
    expect(requests, 1);
    expect(second.provenance!.isCached, isTrue);
    expect(second.hadith, '- : إنما الأعمال بالنيات');
    expect(second.hadith, isNot(first.hadith));
    expect(second.content, first.content);
  });
  test(
    'unknown challenge is never admitted as an empty successful raw response',
    () async {
      final cache = CacheService(
        database: CacheDatabase(NativeDatabase.memory()),
      );
      addTearDown(cache.dispose);
      var requests = 0;
      final http = DorarHttpClient(
        client: MockClient((r) async {
          requests++;
          return createUtf8Response(
            '<html>Please verify your browser</html>',
            200,
          );
        }),
      );
      addTearDown(http.dispose);
      final service = HadithService(client: http, cache: cache);
      for (var i = 0; i < 2; i++) {
        await expectLater(
          service.searchViaSite(const HadithSearchParams(value: 'اختبار')),
          throwsA(isA<DorarParseException>()),
        );
      }
      expect(requests, 2);
    },
  );
  test('prose page two uses AJAX fragments, with independent empty-page recognition', () async {
    final cache = CacheService(
      database: CacheDatabase(NativeDatabase.memory()),
    );
    addTearDown(cache.dispose);
    final http = DorarHttpClient(
      client: MockClient((r) async {
        final page = r.url.queryParameters['page'];
        if (page != '1') {
          expect(r.headers['X-Requested-With'], 'XMLHttpRequest');
        }
        return createUtf8Response(
          source(
            page == '1000'
                ? 'prose_0_page9999_ajax'
                : page == '2'
                ? 'prose_0_page2_ajax'
                : r.url.queryParameters['q'] == 'zxqvnrplm'
                ? 'prose_empty'
                : 'prose_0',
          ),
          200,
        );
      }),
    );
    addTearDown(http.dispose);
    final service = SharhService(client: http, cache: cache);
    final first = await service.searchText(
      const SharhTextSearchParams(value: 'الصلاة'),
    );
    final second = await service.searchText(
      const SharhTextSearchParams(value: 'الصلاة', page: 2),
    );
    expect(second.data, hasLength(15));
    expect(second.data.first.id, isNot(first.data.first.id));
    expect(
      (await service.searchText(
        const SharhTextSearchParams(value: 'الصلاة', page: 1000),
      )).data,
      isEmpty,
    );
    expect(
      (await service.searchText(
        const SharhTextSearchParams(value: 'zxqvnrplm'),
      )).data,
      isEmpty,
    );
  });
  test('all eight usul and six asbab pages parse their independent source contracts', () async {
    final cache = CacheService(
      database: CacheDatabase(NativeDatabase.memory()),
    );
    addTearDown(cache.dispose);
    final http = DorarHttpClient(
      client: MockClient(
        (r) async => createUtf8Response(
          source(
            '${r.url.queryParameters.containsKey('osoul') ? 'usul' : 'asbab'}_${r.url.pathSegments.last}',
          ),
          200,
        ),
      ),
    );
    addTearDown(http.dispose);
    final service = HadithService(client: http, cache: cache);
    for (final file in Directory(
      'test/fixtures/upstream',
    ).listSync().whereType<File>()) {
      final name = file.uri.pathSegments.last;
      if (name.startsWith('usul_')) {
        final result = await service.getUsul(
          name.substring(5, name.length - 5),
        );
        expect(
          result.metadata.diagnostics!.completeness,
          ParseCompleteness.complete,
        );
      }
      if (name.startsWith('asbab_')) {
        final result = await service.getAsbab(
          name.substring(6, name.length - 5),
        );
        expect(result.data.source.hadithId, name.substring(6, name.length - 5));
      }
    }
  });
}
