import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith/src/database/cache_database.dart';
import 'package:dorar_hadith/src/services/cache_service.dart';
import 'package:drift/native.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../fixtures/mock_responses.dart';
import '../helpers/test_helpers.dart';

void main() {
  late MockClient mockHttpClient;
  late DorarHttpClient dorarClient;
  late CacheService cacheService;
  late HadithService service;

  setUp(() {
    mockHttpClient = MockClient((request) async {
      final url = request.url.toString();

      // searchViaApi - API endpoint
      if (url.contains('dorar_api.json')) {
        return createJsonUtf8Response(mockHadithSearchApiResponse, 200);
      }

      // searchViaSite - Site endpoint
      if (url.contains('/hadith/search')) {
        if (url.contains('q=error')) {
          return createUtf8Response('Server Error', 500);
        }
        return createUtf8Response(mockHadithSearchSiteResponse, 200);
      }

      // getById - Single hadith
      if (url.contains('/h/123') && !url.contains('?')) {
        return createUtf8Response(mockHadithByIdResponse, 200);
      }
      if (url.contains('/h/404')) {
        return createUtf8Response('Not Found', 404);
      }

      // getSimilar - Similar hadiths
      if (url.contains('/h/123?sims=1')) {
        return createUtf8Response(mockSimilarHadithsResponse, 200);
      }

      // getAlternate - Alternate sahih hadith
      if (url.contains('/h/123?alts=1')) {
        return createUtf8Response(mockAlternateHadithResponse, 200);
      }

      // getUsul - Usul hadith with sources
      if (url.contains('/h/123?osoul=1')) {
        return createUtf8Response(mockUsulHadithResponse, 200);
      }

      return createUtf8Response('Not Found', 404);
    });

    dorarClient = DorarHttpClient(client: mockHttpClient);
    cacheService = CacheService(
      database: CacheDatabase(NativeDatabase.memory()),
    );
    service = HadithService(client: dorarClient, cache: cacheService);
  });

  tearDown(() async {
    await cacheService.dispose();
  });

  group('HadithService - searchViaApi()', () {
    test('should search hadiths via API and return results', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaApi(params);

      expect(response.data, isNotEmpty);
      expect(response.data.length, greaterThan(0));
      expect(response.data[0].hadith, contains('إنما الأعمال بالنيات'));
    });

    test('should parse API response correctly', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaApi(params);

      final hadith = response.data[0];
      expect(hadith.hadith, isNotEmpty);
      expect(hadith.rawi, 'عمر بن الخطاب');
      expect(hadith.mohdith, 'البخاري');
      expect(hadith.book, 'صحيح البخاري');
    });

    test('should remove numbering from hadith text', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaApi(params);

      // API response has "1 - إنما الأعمال..." but should be cleaned to "إنما الأعمال..."
      expect(response.data[0].hadith, isNot(startsWith('1 -')));
      expect(response.data[0].hadith, contains('إنما الأعمال'));
    });

    test('should respect removeHtml parameter', () async {
      // Test with removeHtml = true
      final paramsClean = HadithSearchParams(value: 'test', removeHtml: true);
      final responseClean = await service.searchViaApi(paramsClean);
      expect(responseClean.data, isNotEmpty);

      // Test with removeHtml = false
      final paramsRaw = HadithSearchParams(value: 'test', removeHtml: false);
      final responseRaw = await service.searchViaApi(paramsRaw);
      expect(responseRaw.data, isNotEmpty);
    });

    test('should cache API search results', () async {
      final params = HadithSearchParams(value: 'test');

      // First call
      final response1 = await service.searchViaApi(params);
      expect(response1.data, isNotEmpty);

      // Second call - should use cache
      final response2 = await service.searchViaApi(params);
      expect(response2.data.length, response1.data.length);
    });

    test('should handle API errors gracefully', () async {
      final errorClient = MockClient((request) async {
        throw Exception('Network error');
      });
      final errorDorarClient = DorarHttpClient(client: errorClient);
      final errorService = HadithService(
        client: errorDorarClient,
        cache: cacheService,
      );

      final params = HadithSearchParams(value: 'test');
      expect(
        () => errorService.searchViaApi(params),
        throwsA(isA<DorarNetworkException>()),
      );
    });
  });

  group('HadithService - searchViaSite()', () {
    test('should search hadiths via site and return results', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaSite(params);

      expect(response.data, isNotEmpty);
      expect(response.data[0].hadith, contains('إنما الأعمال'));
    });

    test('should parse site response correctly', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaSite(params);

      final hadith = response.data[0];
      expect(hadith.hadith, isNotEmpty);
      expect(hadith.rawi, 'عمر بن الخطاب');
      expect(hadith.mohdith, 'البخاري');
      expect(hadith.book, 'صحيح البخاري');
      expect(hadith.hadithId, '123');
    });

    test('should extract hadith ID from site response', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaSite(params);

      expect(response.data[0].hadithId, '123');
    });

    test('should extract sharh metadata', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaSite(params);

      final hadith = response.data[0];
      expect(hadith.hasSharhMetadata, true);
      expect(hadith.sharhMetadata?.id, '456');
    });

    test('should support specialist search', () async {
      final params = HadithSearchParams(value: 'test', specialist: true);
      final response = await service.searchViaSite(params);

      expect(response.data, isNotEmpty);
    });

    test('should cache site search results', () async {
      final params = HadithSearchParams(value: 'test');

      // First call
      final response1 = await service.searchViaSite(params);
      expect(response1.data, isNotEmpty);

      // Second call - should use cache
      final response2 = await service.searchViaSite(params);
      expect(response2.data.length, response1.data.length);
    });

    test('should throw DorarServerException for 500 response', () async {
      final params = HadithSearchParams(value: 'error');

      expect(
        () => service.searchViaSite(params),
        throwsA(isA<DorarServerException>()),
      );
    });

    test('should handle network errors', () async {
      final errorClient = MockClient((request) async {
        throw Exception('Network error');
      });
      final errorDorarClient = DorarHttpClient(client: errorClient);
      final errorService = HadithService(
        client: errorDorarClient,
        cache: cacheService,
      );

      final params = HadithSearchParams(value: 'test');
      expect(
        () => errorService.searchViaSite(params),
        throwsA(isA<DorarNetworkException>()),
      );
    });
  });

  group('HadithService - getById()', () {
    test('should fetch hadith by ID', () async {
      final hadith = await service.getById('123');

      expect(hadith.hadith, contains('إنما الأعمال'));
      expect(hadith.rawi, 'عمر بن الخطاب');
      expect(hadith.mohdith, 'البخاري');
    });

    test('should clean hadith text (remove "- :" pattern)', () async {
      final hadith = await service.getById('123');

      // Response has "- : إنما الأعمال..." but should be cleaned
      expect(hadith.hadith, isNot(contains('- :')));
      expect(hadith.hadith, contains('إنما الأعمال'));
    });

    test('should cache hadith by ID', () async {
      // First call
      final hadith1 = await service.getById('123');
      expect(hadith1.hadith, isNotEmpty);

      // Second call - should use cache
      final hadith2 = await service.getById('123');
      expect(hadith2.hadith, hadith1.hadith);

      final cacheKey = 'https://www.dorar.net/h/123';
      expect(await cacheService.get(cacheKey), isNotNull);
    });

    test('should throw DorarValidationException for empty ID', () async {
      expect(
        () => service.getById(''),
        throwsA(
          isA<DorarValidationException>()
              .having((e) => e.message, 'message', contains('required'))
              .having((e) => e.field, 'field', 'hadithId'),
        ),
      );
    });

    test('should throw DorarNotFoundException for 404', () async {
      expect(
        () => service.getById('404'),
        throwsA(isA<DorarNotFoundException>()),
      );
    });

    test('should handle network errors', () async {
      final errorClient = MockClient((request) async {
        throw Exception('Network error');
      });
      final errorDorarClient = DorarHttpClient(client: errorClient);
      final errorService = HadithService(
        client: errorDorarClient,
        cache: cacheService,
      );

      expect(
        () => errorService.getById('123'),
        throwsA(isA<DorarNetworkException>()),
      );
    });
  });

  group('HadithService - getSimilar()', () {
    test('should fetch similar hadiths', () async {
      final similar = await service.getSimilar('123');

      expect(similar, hasLength(2));
      expect(similar[0].hadith, contains('حديث مشابه 1'));
      expect(similar[1].hadith, contains('حديث مشابه 2'));
    });

    test('should parse similar hadiths correctly', () async {
      final similar = await service.getSimilar('123');

      expect(similar[0].rawi, 'أبو هريرة');
      expect(similar[0].mohdith, 'مسلم');
      expect(similar[1].rawi, 'عائشة');
      expect(similar[1].mohdith, 'البخاري');
    });

    test('should cache similar hadiths', () async {
      // First call
      final similar1 = await service.getSimilar('123');
      expect(similar1, hasLength(2));

      // Second call - should use cache
      final similar2 = await service.getSimilar('123');
      expect(similar2.length, similar1.length);

      final cacheKey = 'https://www.dorar.net/h/123?sims=1';
      expect(await cacheService.get(cacheKey), isNotNull);
    });

    test('should throw DorarValidationException for empty ID', () async {
      expect(
        () => service.getSimilar(''),
        throwsA(
          isA<DorarValidationException>().having(
            (e) => e.field,
            'field',
            'hadithId',
          ),
        ),
      );
    });

    test('should return empty list if no similar hadiths', () async {
      mockHttpClient = MockClient((request) async {
        return createUtf8Response('<html><body></body></html>', 200);
      });
      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = HadithService(client: dorarClient, cache: cacheService);

      final similar = await service.getSimilar('123');
      expect(similar, isEmpty);
    });
  });

  group('HadithService - getAlternate()', () {
    test('should fetch alternate sahih hadith', () async {
      final alternate = await service.getAlternate('123');

      expect(alternate, isNotNull);
      expect(alternate!.hadith, contains('حديث بديل صحيح'));
      expect(alternate.rawi, 'ابن عمر');
      expect(alternate.mohdith, 'مسلم');
    });

    test('should return second border-bottom element', () async {
      final alternate = await service.getAlternate('123');

      // Should skip first element and return second
      expect(alternate, isNotNull);
      expect(alternate!.hadith, isNot(contains('الأصلي')));
      expect(alternate.hadith, contains('بديل'));
    });

    test('should cache alternate hadith', () async {
      // First call
      final alternate1 = await service.getAlternate('123');
      expect(alternate1, isNotNull);

      // Second call - should use cache
      final alternate2 = await service.getAlternate('123');
      expect(alternate2?.hadith, alternate1!.hadith);

      final cacheKey = 'https://www.dorar.net/h/123?alts=1';
      expect(await cacheService.get(cacheKey), isNotNull);
    });

    test('should return null if no alternate found', () async {
      mockHttpClient = MockClient((request) async {
        return createUtf8Response('''
<html><body>
  <div class="border-bottom"><span>Only one hadith</span></div>
</body></html>
''', 200);
      });
      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = HadithService(client: dorarClient, cache: cacheService);

      final alternate = await service.getAlternate('123');
      expect(alternate, isNull);
    });

    test('should throw DorarValidationException for empty ID', () async {
      expect(
        () => service.getAlternate(''),
        throwsA(
          isA<DorarValidationException>().having(
            (e) => e.field,
            'field',
            'hadithId',
          ),
        ),
      );
    });
  });

  group('HadithService - getUsul()', () {
    test('should fetch usul hadith with sources', () async {
      final response = await service.getUsul('123');

      expect(response.data.hadith, isNotNull);
      expect(response.data.hadith.hadith, contains('إنما الأعمال'));
      expect(response.data.sources, hasLength(2));
      expect(response.data.count, 2);
      expect(response.metadata.isCached, isFalse);
      expect(response.metadata.usulSourcesCount, 2);
    });

    test('should parse usul sources correctly', () async {
      final response = await service.getUsul('123');
      final usul = response.data;

      final source1 = usul.sources[0];
      expect(source1.source, 'المصدر الأول');
      expect(source1.chain, 'السلسلة الأولى');
      expect(source1.hadithText, contains('نص الحديث الأول'));

      final source2 = usul.sources[1];
      expect(source2.source, 'المصدر الثاني');
      expect(source2.chain, 'السلسلة الثانية');
      expect(source2.hadithText, contains('نص الحديث الثاني'));
    });

    test('should extract main hadith from first border-bottom', () async {
      final response = await service.getUsul('123');
      final usul = response.data;

      expect(usul.hadith.hadith, contains('إنما الأعمال'));
      expect(usul.hadith.rawi, 'عمر بن الخطاب');
      expect(usul.hadith.mohdith, 'البخاري');
    });

    test('should cache usul hadith', () async {
      // First call
      final usul1 = await service.getUsul('123');
      expect(usul1.data.sources, hasLength(2));
      expect(usul1.metadata.isCached, isFalse);

      // Second call - should use cache
      final usul2 = await service.getUsul('123');
      expect(usul2.data.count, usul1.data.count);
      expect(usul2.metadata.isCached, isTrue);

      final cacheKey = 'https://www.dorar.net/h/123?osoul=1';
      expect(await cacheService.get(cacheKey), isNotNull);
    });

    test('should throw DorarValidationException for empty ID', () async {
      expect(
        () => service.getUsul(''),
        throwsA(
          isA<DorarValidationException>().having(
            (e) => e.field,
            'field',
            'hadithId',
          ),
        ),
      );
    });

    test('should handle usul with no sources', () async {
      mockHttpClient = MockClient((request) async {
        return createUtf8Response('''
<html><body>
  <div class="border-bottom">
    <span>Main hadith</span>
    <table><tr><td class="label">Narrator:</td><td>Umar</td></tr></table>
  </div>
</body></html>
''', 200);
      });
      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = HadithService(client: dorarClient, cache: cacheService);

      final response = await service.getUsul('123');
      expect(response.data.sources, isEmpty);
      expect(response.data.count, 0);
      expect(response.metadata.usulSourcesCount, 0);
    });
  });

  group('HadithService - clearCache()', () {
    test('should clear all cached data', () async {
      // Populate cache
      await service.getById('123');
      await service.getSimilar('123');

      expect(await cacheService.get('https://www.dorar.net/h/123'), isNotNull);
      expect(
        await cacheService.get('https://www.dorar.net/h/123?sims=1'),
        isNotNull,
      );

      // Clear cache
      await service.clearCache();

      expect(await cacheService.get('https://www.dorar.net/h/123'), isNull);
      expect(
        await cacheService.get('https://www.dorar.net/h/123?sims=1'),
        isNull,
      );
    });
  });

  group('HadithService - Edge Cases', () {
    test('should handle large hadith IDs', () async {
      mockHttpClient = MockClient((request) async {
        if (request.url.toString().contains('/h/999999')) {
          return createUtf8Response(mockHadithByIdResponse, 200);
        }
        return createUtf8Response('Not Found', 404);
      });
      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = HadithService(client: dorarClient, cache: cacheService);

      final hadith = await service.getById('999999');
      expect(hadith.hadith, isNotEmpty);
    });

    test('should preserve original text without over-sanitization', () async {
      final hadith = await service.getById('123');
      expect(hadith.hadith, contains('إنما الأعمال'));
      expect(hadith.rawi, contains('عمر'));
    });

    test('should handle empty search results', () async {
      mockHttpClient = MockClient((request) async {
        return createJsonUtf8Response('''
{
  "ahadith": {
    "result": ""
  }
}
''', 200);
      });
      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = HadithService(client: dorarClient, cache: cacheService);

      final params = HadithSearchParams(value: 'test');

      // Should throw exception when no hadiths found
      expect(
        () => service.searchViaApi(params),
        throwsA(isA<DorarServerException>()),
      );
    });
  });

  group('HadithService - Model Validation', () {
    test('should support JSON serialization for search results', () async {
      final params = HadithSearchParams(value: 'test');
      final response = await service.searchViaApi(params);

      final hadith = response.data[0];
      final json = hadith.toJson();
      final reconstructed = DetailedHadith.fromJson(json);

      expect(reconstructed.hadith, hadith.hadith);
      expect(reconstructed.rawi, hadith.rawi);
      expect(reconstructed.mohdith, hadith.mohdith);
    });

    test('should validate all Hadith fields are populated', () async {
      final hadith = await service.getById('123');

      expect(hadith.hadith, isNotEmpty);
      expect(hadith.rawi, isNotEmpty);
      expect(hadith.mohdith, isNotEmpty);
      expect(hadith.book, isNotEmpty);
    });
  });

  group('HadithService - Cache Behavior', () {
    test('should cache different methods independently', () async {
      await service.getById('123');
      await service.getSimilar('123');
      await service.getAlternate('123');
      await service.getUsul('123');

      expect(await cacheService.get('https://www.dorar.net/h/123'), isNotNull);
      expect(
        await cacheService.get('https://www.dorar.net/h/123?sims=1'),
        isNotNull,
      );
      expect(
        await cacheService.get('https://www.dorar.net/h/123?alts=1'),
        isNotNull,
      );
      expect(
        await cacheService.get('https://www.dorar.net/h/123?osoul=1'),
        isNotNull,
      );
    });
  });
}
