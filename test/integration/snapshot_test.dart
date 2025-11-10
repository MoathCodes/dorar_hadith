import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/snapshot_loader.dart';
import '../helpers/test_helpers.dart';

/// Example tests demonstrating snapshot testing with real API responses
///
/// These tests use actual API responses captured from Dorar.net
/// to verify that our parsers work correctly with real data.
void main() {
  group('Snapshot Testing Examples', () {
    test('should parse real hadith search API response', () async {
      // Load real API response captured from Dorar.net
      final responseBody = getSnapshotBody('hadith_search_api');

      // Create mock client that returns the real response
      final mockClient = MockClient((request) async {
        return createJsonUtf8Response(responseBody, 200);
      });

      final client = DorarClient(
        httpClient: DorarHttpClient(client: mockClient),
      );

      // Test with real data structure
      final params = HadithSearchParams(value: 'test');
      final results = await client.searchHadith(params);

      // Verify we got results (searchHadith returns ApiResponse)
      expect(results.data, isNotEmpty);

      // Verify Arabic text is present
      for (final hadith in results.data) {
        expect(hadith.hadith, isNotEmpty);
        expect(hadith.hadith, matches(RegExp(r'[\u0600-\u06FF]')));
      }

      await client.dispose();
    });

    test('should parse real sharh response', () async {
      // Load real sharh page captured from Dorar.net
      final responseBody = getSnapshotBody('sharh_by_id');

      final mockClient = MockClient((request) async {
        return createUtf8Response(responseBody, 200);
      });

      final client = DorarClient(
        httpClient: DorarHttpClient(client: mockClient),
      );

      final sharh = await client.getSharhById('2981');

      // Verify structure
      expect(sharh.hadith, isNotEmpty);
      expect(sharh.sharhMetadata, isNotNull);
      expect(sharh.sharhMetadata!.sharh, isNotNull);

      // Verify Arabic text
      expect(sharh.hadith, matches(RegExp(r'[\u0600-\u06FF]')));

      await client.dispose();
    });

    test('should parse real mohdith (scholar) response', () async {
      // Load real Imam Bukhari page
      final responseBody = getSnapshotBody('mohdith_bukhari');

      final mockClient = MockClient((request) async {
        return createUtf8Response(responseBody, 200);
      });

      final dorarClient = DorarHttpClient(client: mockClient);
      final service = MohdithService(client: dorarClient);

      final scholar = await service.getById('256');

      // Verify structure
      expect(scholar.name, contains('البخاري'));
      expect(scholar.info, isNotEmpty);

      // Verify Arabic text
      expect(scholar.name, matches(RegExp(r'[\u0600-\u06FF]')));
      expect(scholar.info, matches(RegExp(r'[\u0600-\u06FF]')));

      dorarClient.dispose();
    });

    test('should parse real book response', () async {
      // Load real Sahih Bukhari book page
      final responseBody = getSnapshotBody('book_sahih_bukhari');

      final mockClient = MockClient((request) async {
        return createUtf8Response(responseBody, 200);
      });

      final dorarClient = DorarHttpClient(client: mockClient);
      final service = BookService(client: dorarClient);

      final book = await service.getById('6216');

      // Verify structure
      expect(book.name, isNotEmpty);

      // Verify Arabic text
      expect(book.name, matches(RegExp(r'[\u0600-\u06FF]')));

      dorarClient.dispose();
    });

    // Note: We previously had a test for 404 responses, but all snapshots now
    // use valid IDs and return 200. Error handling is tested in unit tests.

    test('should list all available snapshots', () {
      final snapshots = listSnapshots();

      // We should have captured at least these
      expect(snapshots, contains('hadith_search_api'));
      expect(snapshots, contains('sharh_by_id'));
      expect(snapshots, contains('mohdith_bukhari'));
      expect(snapshots, contains('book_sahih_bukhari'));

      print('Available snapshots: ${snapshots.length}');
      for (final name in snapshots) {
        final metadata = getSnapshotMetadata(name);
        print('  - $name: ${metadata['description']}');
      }
    });
  });
}
