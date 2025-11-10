import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('SearchZone', () {
    test('should have correct number of values', () {
      expect(SearchZone.values, hasLength(5));
    });

    test('should have correct enum values', () {
      expect(SearchZone.values, contains(SearchZone.all));
      expect(SearchZone.values, contains(SearchZone.marfoo));
      expect(SearchZone.values, contains(SearchZone.qudsi));
      expect(SearchZone.values, contains(SearchZone.sahabaAthar));
      expect(SearchZone.values, contains(SearchZone.sharh));
    });

    group('ID mapping', () {
      test('all should have ID "*"', () {
        expect(SearchZone.all.id, equals('*'));
      });

      test('marfoo should have ID "0"', () {
        expect(SearchZone.marfoo.id, equals('0'));
      });

      test('qudsi should have ID "1"', () {
        expect(SearchZone.qudsi.id, equals('1'));
      });

      test('sahabaAthar should have ID "2"', () {
        expect(SearchZone.sahabaAthar.id, equals('2'));
      });

      test('sharh should have ID "3"', () {
        expect(SearchZone.sharh.id, equals('3'));
      });
    });

    group('Labels', () {
      test('all should have correct Arabic label', () {
        expect(SearchZone.all.label, equals('جميع الأحاديث'));
      });

      test('marfoo should have correct Arabic label', () {
        expect(SearchZone.marfoo.label, equals('الأحاديث المرفوعة'));
      });

      test('qudsi should have correct Arabic label', () {
        expect(SearchZone.qudsi.label, equals('الأحاديث القدسية'));
      });

      test('sahabaAthar should have correct Arabic label', () {
        expect(SearchZone.sahabaAthar.label, equals('آثار الصحابة'));
      });

      test('sharh should have correct Arabic label', () {
        expect(SearchZone.sharh.label, equals('شروح الأحاديث'));
      });
    });

    group('toQueryParam', () {
      test('should return ID for all zones', () {
        for (final zone in SearchZone.values) {
          expect(zone.toQueryParam(), equals(zone.id));
        }
      });

      test('should return correct query params', () {
        expect(SearchZone.all.toQueryParam(), equals('*'));
        expect(SearchZone.marfoo.toQueryParam(), equals('0'));
        expect(SearchZone.qudsi.toQueryParam(), equals('1'));
        expect(SearchZone.sahabaAthar.toQueryParam(), equals('2'));
        expect(SearchZone.sharh.toQueryParam(), equals('3'));
      });
    });

    group('toString', () {
      test('should return label', () {
        for (final zone in SearchZone.values) {
          expect(zone.toString(), equals(zone.label));
        }
      });

      test('should return Arabic labels', () {
        expect(SearchZone.all.toString(), contains('جميع'));
        expect(SearchZone.marfoo.toString(), contains('المرفوعة'));
        expect(SearchZone.qudsi.toString(), contains('القدسية'));
      });
    });

    group('fromId', () {
      test('should find zone by valid ID', () {
        expect(SearchZone.fromId('*'), equals(SearchZone.all));
        expect(SearchZone.fromId('0'), equals(SearchZone.marfoo));
        expect(SearchZone.fromId('1'), equals(SearchZone.qudsi));
        expect(SearchZone.fromId('2'), equals(SearchZone.sahabaAthar));
        expect(SearchZone.fromId('3'), equals(SearchZone.sharh));
      });

      test('should return null for invalid ID', () {
        expect(SearchZone.fromId('99'), isNull);
        expect(SearchZone.fromId('invalid'), isNull);
        expect(SearchZone.fromId(''), isNull);
      });

      test('should handle exact ID matching', () {
        expect(SearchZone.fromId('*'), isNotNull);
        expect(SearchZone.fromId('**'), isNull); // Different string
      });
    });

    group('Enum ordering', () {
      test('should maintain order from all to specific types', () {
        expect(SearchZone.values[0], equals(SearchZone.all));
        expect(SearchZone.values[1], equals(SearchZone.marfoo));
        expect(SearchZone.values[2], equals(SearchZone.qudsi));
        expect(SearchZone.values[3], equals(SearchZone.sahabaAthar));
        expect(SearchZone.values[4], equals(SearchZone.sharh));
      });
    });

    group('Usage in collections', () {
      test('should work in List', () {
        final zones = [SearchZone.marfoo, SearchZone.qudsi];

        expect(zones, hasLength(2));
        expect(zones, contains(SearchZone.marfoo));
      });

      test('should work in Set', () {
        final zones = {SearchZone.marfoo, SearchZone.qudsi};

        expect(zones, hasLength(2));
      });

      test('should work as Map keys', () {
        final zoneMap = {
          SearchZone.marfoo: 'Attributed to Prophet',
          SearchZone.qudsi: 'Divine Hadith',
          SearchZone.sahabaAthar: 'Companion narrations',
        };

        expect(zoneMap[SearchZone.marfoo], equals('Attributed to Prophet'));
        expect(zoneMap[SearchZone.qudsi], equals('Divine Hadith'));
      });
    });

    group('Hadith classification semantics', () {
      test('marfoo represents prophetic hadiths', () {
        // Marfoo = attributed to the Prophet (pbuh)
        expect(SearchZone.marfoo.label, equals('الأحاديث المرفوعة'));
      });

      test('qudsi represents divine hadiths', () {
        // Qudsi = divine hadith (words of Allah narrated by Prophet)
        expect(SearchZone.qudsi.label, equals('الأحاديث القدسية'));
      });

      test('sahabaAthar represents companion narrations', () {
        // Athar = narrations from Companions
        expect(SearchZone.sahabaAthar.label, equals('آثار الصحابة'));
      });

      test('sharh represents hadith explanations', () {
        // Sharh = explanations/commentaries
        expect(SearchZone.sharh.label, equals('شروح الأحاديث'));
      });

      test('all includes all types', () {
        expect(SearchZone.all.label, equals('جميع الأحاديث'));
      });
    });

    group('Equality', () {
      test('should be equal to itself', () {
        expect(SearchZone.marfoo, equals(SearchZone.marfoo));
      });

      test('should not be equal to different zone', () {
        expect(SearchZone.marfoo, isNot(equals(SearchZone.qudsi)));
      });

      test('should have consistent hashCode', () {
        final zone1 = SearchZone.marfoo;
        final zone2 = SearchZone.marfoo;

        expect(zone1.hashCode, equals(zone2.hashCode));
      });
    });

    group('API compatibility', () {
      test('should have IDs matching API expectations', () {
        // Verify IDs match the original API
        expect(SearchZone.all.id, equals('*'));
        expect(SearchZone.marfoo.id, equals('0'));
        expect(SearchZone.qudsi.id, equals('1'));
        expect(SearchZone.sahabaAthar.id, equals('2'));
        expect(SearchZone.sharh.id, equals('3'));
      });
    });
  });
}
