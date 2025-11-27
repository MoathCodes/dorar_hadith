import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../fixtures/mock_responses.dart';
import '../helpers/test_helpers.dart';

void main() {
  late MockClient mockHttpClient;
  late DorarHttpClient dorarClient;
  late DorarClient client;

  setUpAll(() {
    // Suppress drift multi-database warnings triggered by repeated in-memory database instantiations in tests.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() {
    mockHttpClient = MockClient((request) async {
      final url = request.url.toString();

      // Data endpoints - match exact DorarEndpoints URLs
      if (url.contains('/data/book')) {
        return createJsonUtf8Response(MockResponses.booksData, 200);
      }
      if (url.contains('/data/degree')) {
        return createJsonUtf8Response(MockResponses.degreesData, 200);
      }
      if (url.contains('/data/methodSearch')) {
        return createJsonUtf8Response(MockResponses.methodSearchData, 200);
      }
      if (url.contains('/data/mohdith')) {
        return createJsonUtf8Response(MockResponses.mohdithData, 200);
      }
      if (url.contains('/data/rawi')) {
        return createJsonUtf8Response(MockResponses.rawiData, 200);
      }
      if (url.contains('/data/zoneSearch')) {
        return createJsonUtf8Response(MockResponses.zoneSearchData, 200);
      }

      // Mohdith by ID
      if (url.contains(RegExp(r'/hadith/mhd/\d+$'))) {
        return createUtf8Response(mockMohdithPageResponse, 200);
      }

      // Book by ID
      if (url.contains(RegExp(r'/hadith/book-card/\d+$'))) {
        return createJsonUtf8Response(mockBookPageResponse, 200);
      }

      // Sharh by ID
      if (url.contains(RegExp(r'/sharh/\d+$'))) {
        return createUtf8Response(mockSharhPageResponse, 200);
      }

      // Sharh search (hadith search for sharh IDs)
      if (url.contains('/hadith/search')) {
        return createUtf8Response(mockSharhSearchResponse, 200);
      }

      // Hadith search API
      if (url.contains('/dorar_api.json')) {
        return createJsonUtf8Response(mockHadithSearchApiResponse, 200);
      }

      // Hadith by ID
      if (url.contains(RegExp(r'/h/\d+')) && !url.contains('?')) {
        return createUtf8Response(mockHadithByIdResponse, 200);
      }

      // Similar hadiths
      if (url.contains('sims=1')) {
        return createUtf8Response(mockSimilarHadithsResponse, 200);
      }

      // Alternate hadiths
      if (url.contains('alts=1')) {
        return createUtf8Response(mockAlternateHadithResponse, 200);
      }

      // Usul hadiths
      if (url.contains('osoul=1')) {
        return createUtf8Response(mockUsulHadithResponse, 200);
      }

      return createUtf8Response('Not Found', 404);
    });

    dorarClient = DorarHttpClient(client: mockHttpClient);
    client = DorarClient(httpClient: dorarClient);
  });

  tearDown(() async {
    await client.dispose();
  });

  group('DorarClient - Initialization', () {
    test('should create client with default HTTP client', () async {
      final defaultClient = DorarClient();
      expect(defaultClient, isNotNull);
      expect(defaultClient.mohdith, isNotNull);
      expect(defaultClient.book, isNotNull);
      expect(defaultClient.sharh, isNotNull);
      expect(defaultClient.hadith, isNotNull);
      await defaultClient.dispose();
    });

    test('should create client with custom HTTP client', () {
      expect(client, isNotNull);
      expect(client.hadith, isNotNull);
    });
  });

  group('DorarClient - Service Access', () {
    test('should provide access to MohdithService', () {
      expect(client.mohdith, isA<MohdithService>());
    });

    test('should provide access to BookService', () {
      expect(client.book, isA<BookService>());
    });

    test('should provide access to SharhService', () {
      expect(client.sharh, isA<SharhService>());
    });

    test('should provide access to HadithService', () {
      expect(client.hadith, isA<HadithService>());
    });
  });

  group('DorarClient - Reference Service Operations', () {
    test('should search books offline', () async {
      final books = await client.searchBooks('صحيح');
      expect(books, isNotEmpty);
    });

    test('should search scholars offline', () async {
      final scholars = await client.searchMohdith('البخاري');
      expect(scholars, isNotEmpty);
    });

    test('should search narrators in database', () async {
      final narrators = await client.searchRawi('أبو');
      expect(narrators, isNotEmpty);
    });
  });

  group('DorarClient - Service Operations', () {
    test('should get mohdith by ID', () async {
      final mohdith = await client.mohdith.getById('256');
      expect(mohdith, isNotNull);
      expect(mohdith.name, isNotEmpty);
    });

    test('should get book by ID', () async {
      final book = await client.book.getById('6216');
      expect(book, isNotNull);
      expect(book.name, isNotEmpty);
    });

    test('should get sharh by ID', () async {
      final sharh = await client.sharh.getById('123');
      expect(sharh, isNotNull);
    });

    test('should search hadith via API', () async {
      final params = HadithSearchParams(value: 'intentions');
      final results = await client.hadith.searchViaApi(params);
      expect(results, isNotNull);
      expect(results.data, isNotEmpty);
    });

    test('should search hadith via site', () async {
      final params = HadithSearchParams(value: 'intentions');
      final results = await client.hadith.searchViaSite(params);
      expect(results, isNotNull);
      expect(results.data, isNotEmpty);
    });
  });

  group('DorarClient - Hadith Detail Operations', () {
    test('should get hadith by ID', () async {
      final hadith = await client.hadith.getById('123');
      expect(hadith, isNotNull);
      expect(hadith.hadith, contains('إنما الأعمال'));
    });

    test('should get similar hadiths', () async {
      final similar = await client.hadith.getSimilar('123');
      expect(similar, isNotNull);
      expect(similar, isNotEmpty);
    });

    test('should get alternate sahih hadith', () async {
      final alternate = await client.hadith.getAlternate('123');
      expect(alternate, isNotNull);
    });

    test('should get usul hadith with sources', () async {
      final response = await client.hadith.getUsul('123');
      expect(response, isNotNull);
      expect(response.data, isNotNull);
      expect(response.data.hadith, isNotNull);
      expect(response.metadata.isCached, isFalse);
    });
  });

  group('DorarClient - Cache Management', () {
    test('should cache results across calls', () async {
      // First call
      final params = HadithSearchParams(value: 'intentions');
      final results1 = await client.hadith.searchViaApi(params);

      // Second call - should use cache
      final results2 = await client.hadith.searchViaApi(params);

      expect(results1.data.length, results2.data.length);
    });

    test('should clear individual service caches', () async {
      // Populate hadith cache
      final params = HadithSearchParams(value: 'intentions');
      await client.hadith.searchViaApi(params);

      // Clear only hadith cache
      client.hadith.clearCache();

      // Should not throw
      expect(() => client.hadith.clearCache(), returnsNormally);
    });
  });

  group('DorarClient - Error Handling', () {
    test('should handle network errors gracefully', () async {
      final errorClient = MockClient((request) async {
        throw Exception('Network error');
      });

      final errorDorarClient = DorarHttpClient(client: errorClient);
      final errorTestClient = DorarClient(httpClient: errorDorarClient);

      final params = HadithSearchParams(value: 'test');
      expect(
        () => errorTestClient.hadith.searchViaApi(params),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle invalid responses', () async {
      final invalidClient = MockClient((request) async {
        return createUtf8Response('Invalid JSON', 200);
      });

      final invalidDorarClient = DorarHttpClient(client: invalidClient);
      final invalidTestClient = DorarClient(httpClient: invalidDorarClient);

      final params = HadithSearchParams(value: 'test');
      expect(
        () => invalidTestClient.hadith.searchViaApi(params),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('DorarClient - End-to-End Scenarios', () {
    test('should complete full hadith search workflow', () async {
      // 1. Search for hadiths
      final searchParams = HadithSearchParams(value: 'intentions');
      final searchResults = await client.hadith.searchViaApi(searchParams);
      expect(searchResults.data, isNotEmpty);

      // 2. Get hadith by ID
      final hadith = await client.hadith.getById('123');
      expect(hadith, isNotNull);

      // 3. Get similar hadiths
      final similar = await client.hadith.getSimilar('123');
      expect(similar, isNotEmpty);

      // 4. Get usul/sources
      final usul = await client.hadith.getUsul('123');
      expect(usul.data.hadith, isNotNull);
      expect(usul.metadata.isCached, isFalse);
    });

    test('should complete reference data workflow', () async {
      // 1. Search scholars
      final scholars = await client.searchMohdith('البخاري');
      expect(scholars, isNotEmpty);

      // 2. Get mohdith by ID
      final mohdith = await client.mohdith.getById('256');
      expect(mohdith, isNotNull);

      // 3. Search books
      final books = await client.searchBooks('صحيح');
      expect(books, isNotEmpty);

      // 4. Get book by ID
      final book = await client.book.getById('6216');
      expect(book, isNotNull);
    });
  });

  group('DorarClient - Convenience Methods', () {
    test('should search hadith using convenience method', () async {
      final params = HadithSearchParams(value: 'intentions', page: 1);
      final results = await client.searchHadith(params);
      expect(results, isNotNull);
      expect(results.data, isNotEmpty);
    });

    test('should search hadith detailed using convenience method', () async {
      final params = HadithSearchParams(value: 'intentions');
      final results = await client.searchHadithDetailed(params);
      expect(results, isNotNull);
      expect(results.data, isNotEmpty);
    });

    test('should get hadith by ID using convenience method', () async {
      final hadith = await client.getHadithById('123');
      expect(hadith, isNotNull);
      expect(hadith.hadith, contains('إنما الأعمال'));
    });

    test('should get sharh by ID using convenience method', () async {
      final sharh = await client.getSharhById('123');
      expect(sharh, isNotNull);
    });

    test('should search books using reference convenience method', () async {
      final expected = await client.bookRef.searchBook('صحيح', limit: 5);
      final viaClient = await client.searchBooks('صحيح', limit: 5);
      expect(viaClient, orderedEquals(expected));
    });

    test('should search scholars using reference convenience method', () async {
      final expected = await client.mohdithRef.searchMohdith(
        'البخاري',
        limit: 5,
      );
      final viaClient = await client.searchMohdith('البخاري', limit: 5);
      expect(viaClient, orderedEquals(expected));
    });

    test(
      'should search narrators using reference convenience method',
      () async {
        const query = 'عمر بن الخطاب';
        const searchLimit = 200;
        final expected = await client.rawiRef.searchRawi(
          query,
          limit: searchLimit,
        );
        final viaClient = await client.searchRawi(query, limit: searchLimit);
        expect(viaClient, orderedEquals(expected));
      },
    );
  });

  group('DorarClient - Resource Management', () {
    test('should dispose of resources', () async {
      final testClient = DorarClient(httpClient: dorarClient);
      await testClient.dispose();
      await expectLater(testClient.dispose(), completes);
    });

    test('should clear cache before disposal', () async {
      final testClient = DorarClient(httpClient: dorarClient);

      // Populate cache
      final params = HadithSearchParams(value: 'test');
      await testClient.hadith.searchViaApi(params);

      // Dispose (should clear cache internally)
      await testClient.dispose();

      await expectLater(testClient.dispose(), completes);
    });

    test('should close rawi reference database on dispose', () async {
      final testClient = DorarClient(httpClient: dorarClient);

      // Ensure database opened at least once before disposal.
      final initialResults = await testClient.searchRawi('عمر', limit: 5);
      expect(initialResults, isNotEmpty);

      await testClient.dispose();

      await expectLater(
        testClient.searchRawi('عمر'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
