import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('HadithDegree', () {
    test('should have correct number of values', () {
      expect(HadithDegree.values, hasLength(5));
    });

    test('should have correct enum values', () {
      expect(HadithDegree.values, contains(HadithDegree.all));
      expect(HadithDegree.values, contains(HadithDegree.authenticHadith));
      expect(HadithDegree.values, contains(HadithDegree.authenticChain));
      expect(HadithDegree.values, contains(HadithDegree.weakHadith));
      expect(HadithDegree.values, contains(HadithDegree.weakChain));
    });

    group('ID mapping', () {
      test('all should have ID "0"', () {
        expect(HadithDegree.all.id, equals('0'));
      });

      test('authenticHadith should have ID "1"', () {
        expect(HadithDegree.authenticHadith.id, equals('1'));
      });

      test('authenticChain should have ID "2"', () {
        expect(HadithDegree.authenticChain.id, equals('2'));
      });

      test('weakHadith should have ID "3"', () {
        expect(HadithDegree.weakHadith.id, equals('3'));
      });

      test('weakChain should have ID "4"', () {
        expect(HadithDegree.weakChain.id, equals('4'));
      });
    });

    group('Labels', () {
      test('all should have correct Arabic label', () {
        expect(HadithDegree.all.label, equals('جميع الدرجات'));
      });

      test('authenticHadith should have correct label', () {
        expect(
          HadithDegree.authenticHadith.label,
          equals('أحاديث حكم المحدثون عليها بالصحة، ونحو ذلك'),
        );
      });

      test('authenticChain should have correct label', () {
        expect(
          HadithDegree.authenticChain.label,
          equals('أحاديث حكم المحدثون على أسانيدها بالصحة، ونحو ذلك'),
        );
      });

      test('weakHadith should have correct label', () {
        expect(
          HadithDegree.weakHadith.label,
          equals('أحاديث حكم المحدثون عليها بالضعف، ونحو ذلك'),
        );
      });

      test('weakChain should have correct label', () {
        expect(
          HadithDegree.weakChain.label,
          equals('أحاديث حكم المحدثون على أسانيدها بالضعف، ونحو ذلك'),
        );
      });
    });

    group('toQueryParam', () {
      test('should return ID for all degrees', () {
        for (final degree in HadithDegree.values) {
          expect(degree.toQueryParam(), equals(degree.id));
        }
      });

      test('should return correct query params', () {
        expect(HadithDegree.all.toQueryParam(), equals('0'));
        expect(HadithDegree.authenticHadith.toQueryParam(), equals('1'));
        expect(HadithDegree.authenticChain.toQueryParam(), equals('2'));
        expect(HadithDegree.weakHadith.toQueryParam(), equals('3'));
        expect(HadithDegree.weakChain.toQueryParam(), equals('4'));
      });
    });

    group('toString', () {
      test('should return label', () {
        for (final degree in HadithDegree.values) {
          expect(degree.toString(), equals(degree.label));
        }
      });
    });

    group('fromId', () {
      test('should find degree by valid ID', () {
        expect(HadithDegree.fromId('0'), equals(HadithDegree.all));
        expect(HadithDegree.fromId('1'), equals(HadithDegree.authenticHadith));
        expect(HadithDegree.fromId('2'), equals(HadithDegree.authenticChain));
        expect(HadithDegree.fromId('3'), equals(HadithDegree.weakHadith));
        expect(HadithDegree.fromId('4'), equals(HadithDegree.weakChain));
      });

      test('should return null for invalid ID', () {
        expect(HadithDegree.fromId('99'), isNull);
        expect(HadithDegree.fromId('invalid'), isNull);
        expect(HadithDegree.fromId(''), isNull);
      });

      test('should handle case-sensitive IDs', () {
        expect(HadithDegree.fromId('1'), isNotNull);
        // IDs are strings, so no case issue, but test edge case
        expect(HadithDegree.fromId('01'), isNull); // Different string
      });
    });

    group('Enum ordering', () {
      test('should maintain order from most inclusive to most specific', () {
        expect(HadithDegree.values[0], equals(HadithDegree.all));
        expect(HadithDegree.values[1], equals(HadithDegree.authenticHadith));
        expect(HadithDegree.values[2], equals(HadithDegree.authenticChain));
        expect(HadithDegree.values[3], equals(HadithDegree.weakHadith));
        expect(HadithDegree.values[4], equals(HadithDegree.weakChain));
      });
    });

    group('Usage in collections', () {
      test('should work in List', () {
        final degrees = [
          HadithDegree.authenticHadith,
          HadithDegree.authenticChain,
        ];

        expect(degrees, hasLength(2));
        expect(degrees, contains(HadithDegree.authenticHadith));
      });

      test('should work in Set', () {
        final degrees = {HadithDegree.authenticHadith, HadithDegree.weakHadith};

        expect(degrees, hasLength(2));
      });

      test('should work as Map keys', () {
        final degreeMap = {
          HadithDegree.authenticHadith: 'Sahih',
          HadithDegree.weakHadith: 'Daif',
        };

        expect(degreeMap[HadithDegree.authenticHadith], equals('Sahih'));
        expect(degreeMap[HadithDegree.weakHadith], equals('Daif'));
      });
    });

    group('Equality', () {
      test('should be equal to itself', () {
        expect(
          HadithDegree.authenticHadith,
          equals(HadithDegree.authenticHadith),
        );
      });

      test('should not be equal to different degree', () {
        expect(
          HadithDegree.authenticHadith,
          isNot(equals(HadithDegree.weakHadith)),
        );
      });

      test('should have consistent hashCode', () {
        final degree1 = HadithDegree.authenticHadith;
        final degree2 = HadithDegree.authenticHadith;

        expect(degree1.hashCode, equals(degree2.hashCode));
      });
    });
  });
}
