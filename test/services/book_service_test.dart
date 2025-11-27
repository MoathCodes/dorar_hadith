import 'dart:convert';

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
  late BookService service;

  setUp(() {
    cacheService = CacheService(
      database: CacheDatabase(NativeDatabase.memory()),
    );
    mockHttpClient = MockClient((request) async {
      final url = request.url.toString();

      // Book by ID endpoint - returns JSON with HTML inside
      if (url.contains('/hadith/book-card/6216')) {
        // Return the HTML as JSON string (as the actual API does)
        return createJsonUtf8Response(jsonEncode(mockBookPageResponse), 200);
      }
      if (url.contains('/hadith/book-card/404')) {
        return createUtf8Response('Not Found', 404);
      }
      if (url.contains('/hadith/book-card/500')) {
        return createUtf8Response('Server Error', 500);
      }
      if (url.contains('/hadith/book-card/99999')) {
        return createJsonUtf8Response(
          jsonEncode('<div>Invalid HTML</div>'),
          200,
        );
      }
      if (url.contains('/hadith/book-card/88888')) {
        return createUtf8Response('Not valid JSON', 200);
      }

      return createUtf8Response('Not Found', 404);
    });

    dorarClient = DorarHttpClient(client: mockHttpClient);
    service = BookService(client: dorarClient, cache: cacheService);
  });

  tearDown(() async {
    await cacheService.dispose();
  });

  group('BookService - getById()', () {
    test('should fetch and parse book information correctly', () async {
      final book = await service.getById('6216');

      expect(book.bookId, '6216');
      expect(book.name, 'صحيح البخاري');
      expect(book.author, 'الإمام محمد بن إسماعيل البخاري');
      expect(book.reviewer, 'مراجعة الشيخ عبد الله');
      expect(book.publisher, 'دار السلام للنشر');
      expect(book.edition, 'الطبعة الأولى');
      expect(book.editionYear, '2020');
    });

    test('should cache book data', () async {
      // First call - should fetch from network
      final book1 = await service.getById('6216');
      expect(book1.name, 'صحيح البخاري');

      // Second call - should retrieve from cache
      final book2 = await service.getById('6216');
      expect(book2.name, 'صحيح البخاري');

      // Verify cache hit
      final cacheKey = 'https://www.dorar.net/hadith/book-card/6216';
      expect(await cacheService.get(cacheKey), isNotNull);
    });

    test('should throw DorarValidationException for empty book ID', () async {
      expect(
        () => service.getById(''),
        throwsA(
          isA<DorarValidationException>()
              .having((e) => e.message, 'message', contains('required'))
              .having((e) => e.field, 'field', 'bookId')
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
              BookInfo,
            ),
          ),
        );
      },
    );

    test('should throw DorarParseException for malformed JSON', () async {
      expect(
        () => service.getById('88888'),
        throwsA(
          isA<DorarParseException>().having(
            (e) => e.message,
            'message',
            contains('parse book data'),
          ),
        ),
      );
    });

    test('should handle network errors gracefully', () async {
      final errorClient = MockClient((request) async {
        throw Exception('Network error');
      });
      final errorDorarClient = DorarHttpClient(client: errorClient);
      final errorService = BookService(
        client: errorDorarClient,
        cache: cacheService,
      );

      expect(
        () => errorService.getById('6216'),
        throwsA(isA<DorarNetworkException>()),
      );
    });
  });

  group('BookService - clearCache()', () {
    test('should clear all cached book data', () async {
      // Fetch book to populate cache
      await service.getById('6216');

      final cacheKey = 'https://www.dorar.net/hadith/book-card/6216';
      expect(await cacheService.get(cacheKey), isNotNull);

      // Clear cache
      await service.clearCache();

      // Verify cache is cleared
      expect(await cacheService.get(cacheKey), isNull);
    });
  });

  group('BookService - Edge Cases', () {
    test('should handle numeric book IDs', () async {
      final book = await service.getById('6216');
      expect(book.bookId, '6216');
    });

    test('should handle large book IDs', () async {
      mockHttpClient = MockClient((request) async {
        final url = request.url.toString();
        if (url.contains('/hadith/book-card/99999')) {
          return createJsonUtf8Response(jsonEncode(mockBookPageResponse), 200);
        }
        return createUtf8Response('Not Found', 404);
      });

      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = BookService(client: dorarClient, cache: cacheService);

      final book = await service.getById('99999');
      expect(book.name, 'صحيح البخاري');
    });

    test('should preserve original text without sanitization', () async {
      final book = await service.getById('6216');
      expect(book.name, contains('صحيح البخاري'));
      expect(book.author, contains('الإمام محمد'));
    });
  });

  group('BookService - Cache Behavior', () {
    test('should cache different books independently', () async {
      mockHttpClient = MockClient((request) async {
        final url = request.url.toString();
        if (url.contains('/hadith/book-card/')) {
          return createJsonUtf8Response(jsonEncode(mockBookPageResponse), 200);
        }
        return createUtf8Response('Not Found', 404);
      });

      dorarClient = DorarHttpClient(client: mockHttpClient);
      service = BookService(client: dorarClient, cache: cacheService);

      // Fetch multiple books
      await service.getById('6216');
      await service.getById('3088');

      // Both should be cached
      expect(
        await cacheService.get('https://www.dorar.net/hadith/book-card/6216'),
        isNotNull,
      );
      expect(
        await cacheService.get('https://www.dorar.net/hadith/book-card/3088'),
        isNotNull,
      );
    });
  });

  group('BookService - Model Validation', () {
    test('should validate all BookInfo fields are populated', () async {
      final book = await service.getById('6216');

      expect(book.bookId, isNotEmpty);
      expect(book.name, isNotEmpty);
      expect(book.author, isNotEmpty);
      expect(book.reviewer, isNotEmpty);
      expect(book.publisher, isNotEmpty);
      expect(book.edition, isNotEmpty);
      expect(book.editionYear, isNotEmpty);
    });

    test('should support JSON serialization round-trip', () async {
      final book = await service.getById('6216');

      // Convert to JSON and back
      final json = book.toJson();
      final reconstructed = BookInfo.fromJson(json);

      expect(reconstructed.bookId, book.bookId);
      expect(reconstructed.name, book.name);
      expect(reconstructed.author, book.author);
      expect(reconstructed.reviewer, book.reviewer);
      expect(reconstructed.publisher, book.publisher);
      expect(reconstructed.edition, book.edition);
      expect(reconstructed.editionYear, book.editionYear);
    });
  });

  group('BookService - Error Messages', () {
    test('should provide clear validation error message', () async {
      try {
        await service.getById('');
        fail('Should have thrown DorarValidationException');
      } on DorarValidationException catch (e) {
        expect(e.message, contains('required'));
        expect(e.field, 'bookId');
      }
    });

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
        expect(e.expectedType, BookInfo);
      }
    });
  });

  group('BookService - JSON Response Format', () {
    test('should handle JSON-wrapped HTML response correctly', () async {
      // The actual API returns JSON string containing HTML
      final book = await service.getById('6216');
      expect(book.name, isNotEmpty);
    });

    test('should extract year from edition year text', () async {
      final book = await service.getById('6216');
      // Should extract "2020" from "2020 AH"
      expect(book.editionYear, '2020');
    });

    test('should remove book number prefix from name', () async {
      final book = await service.getById('6216');
      // Should remove "6216 - " from "6216 - صحيح البخاري"
      expect(book.name, 'صحيح البخاري');
      expect(book.name, isNot(startsWith('6216 -')));
    });
  });
}
