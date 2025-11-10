import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:http/http.dart' show ClientException;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../fixtures/mock_responses.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('MohdithService', () {
    late MohdithService mohdithService;
    late MockClient mockHttpClient;
    late DorarHttpClient dorarClient;
    late CacheManager cacheManager;

    setUp(() {
      cacheManager = CacheManager();
      mockHttpClient = MockClient((request) async {
        final url = request.url.toString();

        if (url.contains('/hadith/mhd/256')) {
          return createUtf8Response(mockMohdithPageResponse, 200);
        } else if (url.contains('/hadith/mhd/999')) {
          return createUtf8Response(mockNotFoundResponse, 404);
        } else if (url.contains('/hadith/mhd/500')) {
          return createUtf8Response(mockServerErrorResponse, 500);
        }

        return createUtf8Response('Not Found', 404);
      });

      dorarClient = DorarHttpClient(client: mockHttpClient);
      mohdithService = MohdithService(client: dorarClient, cache: cacheManager);
    });

    tearDown(() {
      cacheManager.clear();
      dorarClient.dispose();
    });

    group('getById()', () {
      test('should fetch and parse mohdith information', () async {
        final mohdith = await mohdithService.getById('256');

        expect(mohdith.mohdithId, equals('256'));
        expect(mohdith.name, isNotEmpty);
        expect(mohdith.info, isNotEmpty);
        expect(mohdith.info, contains('البخاري'));
      });

      test('should extract mohdith name from h4', () async {
        final mohdith = await mohdithService.getById('256');

        expect(mohdith.name, equals('معلومات المحدث'));
      });

      test('should extract mohdith info from following span', () async {
        final mohdith = await mohdithService.getById('256');

        expect(mohdith.info, equals('الإمام البخاري (194-256 هـ)'));
      });

      test('should cache mohdith data', () async {
        // First call - fetches from API
        await mohdithService.getById('256');
        final cacheKey = 'https://www.dorar.net/hadith/mhd/256';
        expect(cacheManager.has(cacheKey), isTrue);

        // Second call - should use cache
        final mohdith = await mohdithService.getById('256');
        expect(mohdith.mohdithId, equals('256'));
      });

      test('should throw DorarValidationException for empty ID', () async {
        expect(
          () => mohdithService.getById(''),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.field,
              'field',
              equals('mohdithId'),
            ),
          ),
        );
      });

      test('should throw DorarNotFoundException for 404', () async {
        expect(
          () => mohdithService.getById('999'),
          throwsA(isA<DorarNotFoundException>()),
        );
      });

      test('should throw DorarServerException for 500 error', () async {
        expect(
          () => mohdithService.getById('500'),
          throwsA(isA<DorarServerException>()),
        );
      });

      test('should handle malformed HTML', () async {
        mockHttpClient = MockClient((request) async {
          return createUtf8Response('<html><body>Invalid</body></html>', 200);
        });

        dorarClient.dispose();
        dorarClient = DorarHttpClient(client: mockHttpClient);
        mohdithService = MohdithService(
          client: dorarClient,
          cache: cacheManager,
        );

        expect(
          () => mohdithService.getById('256'),
          throwsA(isA<DorarParseException>()),
        );
      });

      test('should handle network errors', () async {
        mockHttpClient = MockClient((request) async {
          throw ClientException('Network error');
        });

        dorarClient.dispose();
        dorarClient = DorarHttpClient(client: mockHttpClient);
        mohdithService = MohdithService(
          client: dorarClient,
          cache: cacheManager,
        );

        expect(
          () => mohdithService.getById('256'),
          throwsA(isA<DorarNetworkException>()),
        );
      });
    });

    group('clearCache()', () {
      test('should clear all cached mohdith data', () async {
        // Populate cache
        await mohdithService.getById('256');

        final cacheKey = 'https://www.dorar.net/hadith/mhd/256';
        expect(cacheManager.has(cacheKey), isTrue);

        // Clear cache
        mohdithService.clearCache();

        // Cache should be empty
        final stats = cacheManager.getStats();
        expect(stats.totalEntries, equals(0));
      });
    });

    group('Edge Cases', () {
      test('should handle numeric mohdithId', () async {
        final mohdith = await mohdithService.getById('256');
        expect(mohdith.mohdithId, equals('256'));
      });

      test('should handle large mohdithId', () async {
        mockHttpClient = MockClient((request) async {
          return createUtf8Response(mockMohdithPageResponse, 200);
        });

        dorarClient.dispose();
        dorarClient = DorarHttpClient(client: mockHttpClient);
        mohdithService = MohdithService(
          client: dorarClient,
          cache: cacheManager,
        );

        final mohdith = await mohdithService.getById('999999');
        expect(mohdith.mohdithId, equals('999999'));
      });

      test('should preserve text in mohdith info', () async {
        final mohdith = await mohdithService.getById('256');

        // Should contain expected text
        expect(mohdith.info, contains('الإمام'));
        expect(mohdith.info, contains('البخاري'));
      });

      test('should handle empty mohdith info gracefully', () async {
        mockHttpClient = MockClient((request) async {
          return createUtf8Response(
            '<html><body><h4>Name</h4><span></span></body></html>',
            200,
          );
        });

        dorarClient.dispose();
        dorarClient = DorarHttpClient(client: mockHttpClient);
        mohdithService = MohdithService(
          client: dorarClient,
          cache: cacheManager,
        );

        final mohdith = await mohdithService.getById('256');
        expect(mohdith.info, isEmpty);
      });
    });

    group('Cache Behavior', () {
      test('should respect cache TTL', () async {
        // Create a service with short TTL cache
        final shortTtlCache = CacheManager(defaultTtl: Duration(seconds: 3));
        final shortTtlService = MohdithService(
          client: dorarClient,
          cache: shortTtlCache,
        );

        // Get mohdith with short TTL
        await shortTtlService.getById('256');
        final cacheKey = 'https://www.dorar.net/hadith/mhd/256';
        expect(shortTtlCache.has(cacheKey), isTrue);

        // Wait for expiry
        await Future.delayed(Duration(seconds: 4));

        expect(shortTtlCache.has(cacheKey), isFalse);
      });

      test('should cache different mohdith independently', () async {
        mockHttpClient = MockClient((request) async {
          return createUtf8Response(mockMohdithPageResponse, 200);
        });

        dorarClient.dispose();
        dorarClient = DorarHttpClient(client: mockHttpClient);
        mohdithService = MohdithService(
          client: dorarClient,
          cache: cacheManager,
        );

        await mohdithService.getById('256');
        await mohdithService.getById('261');

        final key1 = 'https://www.dorar.net/hadith/mhd/256';
        final key2 = 'https://www.dorar.net/hadith/mhd/261';

        expect(cacheManager.has(key1), isTrue);
        expect(cacheManager.has(key2), isTrue);

        // Clear one cache entry
        cacheManager.remove(key1);

        expect(cacheManager.has(key1), isFalse);
        expect(cacheManager.has(key2), isTrue);
      });
    });

    group('Model Validation', () {
      test('should return MohdithInfo with all required fields', () async {
        final mohdith = await mohdithService.getById('256');

        expect(mohdith, isA<MohdithInfo>());
        expect(mohdith.mohdithId, isNotNull);
        expect(mohdith.name, isNotNull);
        expect(mohdith.info, isNotNull);
      });

      test('should create valid MohdithInfo object', () async {
        final mohdith = await mohdithService.getById('256');

        // Test that the object can be used
        final json = mohdith.toJson();
        expect(json['mohdithId'], equals('256'));
        expect(json['name'], isNotEmpty);
        expect(json['info'], isNotEmpty);
      });
    });

    group('Error Messages', () {
      test('should provide descriptive error for validation', () async {
        try {
          await mohdithService.getById('');
          fail('Should have thrown DorarValidationException');
        } catch (e) {
          expect(e, isA<DorarValidationException>());
          final validationError = e as DorarValidationException;
          expect(validationError.message, contains('required'));
          expect(validationError.field, equals('mohdithId'));
        }
      });

      test('should provide descriptive error for not found', () async {
        try {
          await mohdithService.getById('999');
          fail('Should have thrown DorarNotFoundException');
        } catch (e) {
          expect(e, isA<DorarNotFoundException>());
          expect(e.toString(), contains('not found'));
        }
      });

      test('should provide descriptive error for parse failure', () async {
        mockHttpClient = MockClient((request) async {
          return createUtf8Response('<html><body>Invalid</body></html>', 200);
        });

        dorarClient.dispose();
        dorarClient = DorarHttpClient(client: mockHttpClient);
        mohdithService = MohdithService(
          client: dorarClient,
          cache: cacheManager,
        );

        try {
          await mohdithService.getById('256');
          fail('Should have thrown DorarParseException');
        } catch (e) {
          expect(e, isA<DorarParseException>());
          final parseError = e as DorarParseException;
          expect(parseError.expectedType, equals(MohdithInfo));
        }
      });
    });
  });
}
