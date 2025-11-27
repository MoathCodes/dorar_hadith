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
  late SharhService service;

  setUp(() {
    cacheService = CacheService(
      database: CacheDatabase(NativeDatabase.memory()),
    );
    mockHttpClient = MockClient((request) async {
      final url = request.url.toString();

      // Sharh by ID endpoint
      if (url.contains('/hadith/sharh/123')) {
        return createUtf8Response(mockSharhPageResponse, 200);
      }
      if (url.contains('/hadith/sharh/456')) {
        return createUtf8Response(mockSharhPageResponse, 200);
      }
      if (url.contains('/hadith/sharh/404')) {
        return createUtf8Response('Not Found', 404);
      }
      if (url.contains('/hadith/sharh/500')) {
        return createUtf8Response('Server Error', 500);
      }
      if (url.contains('/hadith/sharh/99999')) {
        return createUtf8Response('<div>Invalid HTML</div>', 200);
      }

      // Search endpoint
      if (url.contains('/hadith/search')) {
        if (url.contains('q=test') || url.contains('q=salah')) {
          return createUtf8Response(mockSharhSearchResponse, 200);
        }
        if (url.contains('q=nosharh')) {
          // Response with no sharh IDs (all are '0')
          return createUtf8Response('''
<html><body>
  <div id="home">
    <div class="border-bottom"><a xplain="0">No sharh</a></div>
  </div>
</body></html>
''', 200);
        }
        if (url.contains('q=notfound')) {
          // Response with no results at all
          return createUtf8Response('''
<html><body><div id="home"></div></body></html>
''', 200);
        }
        return createUtf8Response(mockSharhSearchResponse, 200);
      }

      return createUtf8Response('Not Found', 404);
    });

    dorarClient = DorarHttpClient(client: mockHttpClient);
    service = SharhService(client: dorarClient, cache: cacheService);
  });

  tearDown(() async {
    await cacheService.dispose();
  });

  group('SharhService - getById()', () {
    test('should fetch and parse sharh correctly', () async {
      final sharh = await service.getById('123');

      expect(sharh.hadith.hadith, contains('إنما الأعمال بالنيات'));
      expect(sharh.hadith.rawi, 'عمر بن الخطاب');
      expect(sharh.hadith.mohdith, 'البخاري');
      expect(sharh.hadith.book, 'صحيح البخاري');
      expect(sharh.hadith.numberOrPage, '1/1');
      expect(sharh.hadith.grade, 'صحيح');
      expect(sharh.hadith.takhrij, 'متحقق');
      expect(sharh.hadith.hasSharhMetadata, true);
      expect(sharh.sharhMetadata?.id, '123');
      expect(sharh.sharhMetadata?.isContainSharh, true);
      expect(sharh.sharhMetadata?.sharh, isNotEmpty);
    });

    test('should cache sharh data', () async {
      // First call - should fetch from network
      final sharh1 = await service.getById('123');
      expect(sharh1.hadith.hadith, contains('إنما الأعمال'));

      // Second call - should retrieve from cache
      final sharh2 = await service.getById('123');
      expect(sharh2.hadith.hadith, contains('إنما الأعمال'));

      // Verify cache hit
      final cacheKey = 'https://www.dorar.net/hadith/sharh/123';
      expect(await cacheService.get(cacheKey), isNotNull);
    });

    test('should throw DorarValidationException for empty sharh ID', () async {
      expect(
        () => service.getById(''),
        throwsA(
          isA<DorarValidationException>()
              .having((e) => e.message, 'message', contains('required'))
              .having((e) => e.field, 'field', 'sharhId')
              .having((e) => e.rule, 'rule', 'required'),
        ),
      );
    });

    test('should throw DorarNotFoundException for 404 response', () async {
      expect(
        () => service.getById('404'),
        throwsA(
          isA<DorarNotFoundException>().having(
            (e) => e.message,
            'message',
            contains('not found'),
          ),
        ),
      );
    });

    test('should throw DorarServerException for 500 response', () async {
      expect(
        () => service.getById('500'),
        throwsA(
          isA<DorarServerException>().having(
            (e) => e.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });

    test(
      'should throw DorarParseException for invalid HTML structure',
      () async {
        expect(
          () => service.getById('99999'),
          throwsA(
            isA<DorarParseException>().having(
              (e) => e.expectedType,
              'expectedType',
              Sharh,
            ),
          ),
        );
      },
    );

    test('should handle network errors gracefully', () async {
      final errorClient = MockClient((request) async {
        throw Exception('Network error');
      });
      final errorDorarClient = DorarHttpClient(client: errorClient);
      final errorService = SharhService(
        client: errorDorarClient,
        cache: cacheService,
      );

      expect(
        () => errorService.getById('123'),
        throwsA(isA<DorarNetworkException>()),
      );
    });
  });

  group('SharhService - getByText()', () {
    test('should get sharh by hadith text', () async {
      final sharh = await service.getByText('salah');

      expect(sharh.hadith.hadith, isNotEmpty);
      expect(sharh.hadith.hasSharhMetadata, true);
      expect(sharh.sharhMetadata?.id, '123'); // First sharh ID from search
    });

    test('should cache getByText results', () async {
      // First call
      final sharh1 = await service.getByText('salah');
      expect(sharh1.hadith.hadith, isNotEmpty);

      // Second call - should be cached
      final sharh2 = await service.getByText('salah');
      expect(sharh2.hadith.hadith, isNotEmpty);

      final cacheKey = 'https://www.dorar.net/hadith/search?q=salah';
      expect(await cacheService.get(cacheKey), isNotNull);
    });

    test('should support specialist search in getByText', () async {
      // Need to mock specialist tab response
      mockHttpClient = MockClient((request) async {
        final url = request.url.toString();
        if (url.contains('all')) {
          // Specialist search - return response with #specialist tab
          return createUtf8Response('''
<html><body>
  <div id="specialist">
    <div class="border-bottom"><a xplain="789">Specialist hadith</a></div>
  </div>
</body></html>
''', 200);
        }
        if (url.contains('/hadith/sharh/789')) {
          return createUtf8Response(mockSharhPageResponse, 200);
        }
        return createUtf8Response('Not Found', 404);
      });

      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = SharhService(client: dorarClient, cache: cacheService);

      final sharh = await service.getByText('test', specialist: true);

      expect(sharh.hadith.hadith, isNotEmpty);
    });

    test('should throw DorarValidationException for empty text', () async {
      expect(
        () => service.getByText(''),
        throwsA(
          isA<DorarValidationException>()
              .having((e) => e.message, 'message', contains('required'))
              .having((e) => e.field, 'field', 'text')
              .having((e) => e.rule, 'rule', 'required'),
        ),
      );
    });

    test('should throw DorarNotFoundException when no sharh found', () async {
      expect(
        () => service.getByText('notfound'),
        throwsA(
          isA<DorarNotFoundException>()
              .having((e) => e.message, 'message', contains('No sharh found'))
              .having((e) => e.resource, 'resource', 'sharh'),
        ),
      );
    });

    test(
      'should throw DorarNotFoundException when all sharh IDs are "0"',
      () async {
        expect(
          () => service.getByText('nosharh'),
          throwsA(
            isA<DorarNotFoundException>().having(
              (e) => e.message,
              'message',
              contains('No sharh found'),
            ),
          ),
        );
      },
    );
  });

  group('SharhService - Edge Cases', () {
    test('should handle numeric sharh IDs', () async {
      final sharh = await service.getById('123');
      expect(sharh.sharhMetadata?.id, '123');
    });

    test('should handle large sharh IDs', () async {
      mockHttpClient = MockClient((request) async {
        final url = request.url.toString();
        if (url.contains('/hadith/sharh/999999')) {
          return createUtf8Response(mockSharhPageResponse, 200);
        }
        return createUtf8Response('Not Found', 404);
      });

      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = SharhService(client: dorarClient, cache: cacheService);

      final sharh = await service.getById('999999');
      expect(sharh.hadith.hadith, isNotEmpty);
    });

    test('should preserve original text without sanitization', () async {
      mockHttpClient = MockClient((request) async {
        final url = request.url.toString();
        if (url.contains('/hadith/sharh/999999')) {
          return createUtf8Response(mockSharhPageResponse, 200);
        }
        return createUtf8Response('Not Found', 404);
      });

      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = SharhService(client: dorarClient, cache: cacheService);

      final sharh = await service.getById('999999');
      expect(sharh.sharhText, contains('إنما الأعمال بالنيات'));
    });
  });

  group('SharhService - Cache Behavior', () {
    test('should cache different sharh independently', () async {
      // Fetch multiple sharh
      await service.getById('123');
      await service.getById('456');

      // Both should be cached
      expect(
        await cacheService.get('https://www.dorar.net/hadith/sharh/123'),
        isNotNull,
      );
      expect(
        await cacheService.get('https://www.dorar.net/hadith/sharh/456'),
        isNotNull,
      );
    });
  });

  group('SharhService - Model Validation', () {
    test('should validate all Sharh fields are populated', () async {
      final sharh = await service.getById('123');

      expect(sharh.hadith.hadith, isNotEmpty);
      expect(sharh.hadith.rawi, isNotEmpty);
      expect(sharh.hadith.mohdith, isNotEmpty);
      expect(sharh.hadith.book, isNotEmpty);
      expect(sharh.hadith.numberOrPage, isNotEmpty);
      expect(sharh.hadith.grade, isNotEmpty);
      expect(sharh.hadith.takhrij, isNotEmpty);
      expect(sharh.hadith.hasSharhMetadata, true);
      expect(sharh.sharhMetadata, isNotNull);
      expect(sharh.sharhMetadata?.sharh, isNotEmpty);
    });

    test('should support JSON serialization round-trip', () async {
      final sharh = await service.getById('123');

      // Convert to JSON and back
      final json = sharh.toJson();
      final reconstructed = Sharh.fromJson(json);

      expect(reconstructed.hadith, sharh.hadith);
      expect(
        reconstructed.hadith.hasSharhMetadata,
        sharh.hadith.hasSharhMetadata,
      );
      expect(reconstructed.sharhMetadata?.id, sharh.sharhMetadata?.id);
    });
  });

  group('SharhService - Error Messages', () {
    test('should provide clear validation error message for getById', () async {
      try {
        await service.getById('');
        fail('Should have thrown DorarValidationException');
      } on DorarValidationException catch (e) {
        expect(e.message, contains('required'));
        expect(e.field, 'sharhId');
      }
    });

    test(
      'should provide clear validation error message for getByText',
      () async {
        try {
          await service.getByText('');
          fail('Should have thrown DorarValidationException');
        } on DorarValidationException catch (e) {
          expect(e.message, contains('required'));
          expect(e.field, 'text');
        }
      },
    );

    test('should provide clear not found error message', () async {
      try {
        await service.getById('404');
        fail('Should have thrown DorarNotFoundException');
      } on DorarNotFoundException catch (e) {
        expect(e.message, contains('not found'));
      }
    });

    test('should provide clear parse error message', () async {
      try {
        await service.getById('99999');
        fail('Should have thrown DorarParseException');
      } on DorarParseException catch (e) {
        expect(e.message, contains('parse'));
        expect(e.expectedType, Sharh);
      }
    });
  });
}
