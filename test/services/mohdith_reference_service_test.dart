import 'dart:convert';
import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  late MohdithReferenceService service;
  late List<dynamic> rawMohdithData;

  setUpAll(() async {
    final jsonString = await File('assets/data/mohdith.json').readAsString();
    rawMohdithData = json.decode(jsonString) as List<dynamic>;

    service = MohdithReferenceService();
    await service.initialize();
  });

  group('MohdithReferenceService', () {
    test('countMohdith matches raw data entries', () async {
      final total = await service.countMohdith();
      expect(total, rawMohdithData.length);
    });

    test('countMohdith with query filters results', () async {
      final filtered = await service.countMohdith(query: 'الإمام');
      expect(filtered, greaterThan(0));
      expect(filtered, lessThan(rawMohdithData.length));
    });

    test('getAllMohdith respects pagination', () async {
      final firstPage = await service.getAllMohdith(limit: 5, offset: 0);
      final secondPage = await service.getAllMohdith(limit: 5, offset: 5);

      expect(firstPage, hasLength(5));
      expect(secondPage, hasLength(5));
      expect(secondPage.first, isNot(firstPage.first));
    });

    test('getMohdithById returns known scholar', () async {
      final bukhari = await service.getMohdithById('256');

      expect(bukhari, isNotNull);
      expect(bukhari!.name, contains('البخاري'));
    });

    test('getMohdithByIds returns list of existing scholars', () async {
      final ids = ['256', '261', '204'];
      final scholars = await service.getMohdithByIds(ids);

      expect(scholars, hasLength(ids.length));
      expect(scholars.map((s) => s.id), containsAll(ids));
    });

    test('searchMohdith performs fuzzy matching', () async {
      final results = await service.searchMohdith('البُخَارِي');

      expect(results, isNotEmpty);
      expect(results.any((item) => item.id == '256'), isTrue);
    });

    test('searchMohdith with empty query falls back to listing', () async {
      final results = await service.searchMohdith('', limit: 10);
      expect(results, hasLength(10));
    });
  });
}
