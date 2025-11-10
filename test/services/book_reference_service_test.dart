import 'dart:convert';
import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  late BookReferenceService service;
  late List<dynamic> rawBookData;
  late List<String> sampleIds;

  setUpAll(() async {
    final jsonString = await File('assets/data/book.json').readAsString();
    rawBookData = json.decode(jsonString) as List<dynamic>;
    sampleIds = rawBookData
        .take(3)
        .map((entry) => (entry as Map<String, dynamic>)['key'] as String)
        .toList();

    service = BookReferenceService();
    await service.initialize();
  });

  group('BookReferenceService', () {
    test('countBooks matches raw data entries', () async {
      final total = await service.countBooks();
      expect(total, rawBookData.length);
    });

    test('countBooks with query reduces total', () async {
      final filtered = await service.countBooks(query: 'صحيح');
      expect(filtered, greaterThan(0));
      expect(filtered, lessThan(rawBookData.length));
    });

    test('getAllBooks respects pagination', () async {
      final firstPage = await service.getAllBooks(limit: 7, offset: 0);
      final secondPage = await service.getAllBooks(limit: 7, offset: 7);

      expect(firstPage, hasLength(7));
      expect(secondPage, hasLength(7));
      expect(secondPage.first, isNot(firstPage.first));
    });

    test('getBookById returns known title', () async {
      final book = await service.getBookById('6216');

      expect(book, isNotNull);
      expect(book!.name, 'صحيح البخاري');
    });

    test('getBooksByIds filters to existing titles', () async {
      final books = await service.getBooksByIds(sampleIds);

      expect(books, hasLength(sampleIds.length));
      expect(books.map((b) => b.id), containsAll(sampleIds));
    });

    test('searchBook performs fuzzy matching', () async {
      final results = await service.searchBook('صَحِيح');

      expect(results, isNotEmpty);
      expect(results.any((item) => item.id == '6216'), isTrue);
    });

    test('searchBook with empty query falls back to listing', () async {
      final results = await service.searchBook('', limit: 12);
      expect(results, hasLength(12));
    });
  });
}
