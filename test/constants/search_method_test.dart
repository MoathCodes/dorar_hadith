import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('SearchMethod', () {
    test('should have correct number of values', () {
      expect(SearchMethod.values, hasLength(3));
    });

    test('should have correct enum values', () {
      expect(SearchMethod.values, contains(SearchMethod.allWords));
      expect(SearchMethod.values, contains(SearchMethod.anyWord));
      expect(SearchMethod.values, contains(SearchMethod.exactMatch));
    });

    group('ID mapping', () {
      test('allWords should have ID "w"', () {
        expect(SearchMethod.allWords.id, equals('w'));
      });

      test('anyWord should have ID "a"', () {
        expect(SearchMethod.anyWord.id, equals('a'));
      });

      test('exactMatch should have ID "p"', () {
        expect(SearchMethod.exactMatch.id, equals('p'));
      });
    });

    group('Labels', () {
      test('allWords should have correct Arabic label', () {
        expect(SearchMethod.allWords.label, equals('جميع الكلمات'));
      });

      test('anyWord should have correct Arabic label', () {
        expect(SearchMethod.anyWord.label, equals('أي كلمة'));
      });

      test('exactMatch should have correct Arabic label', () {
        expect(SearchMethod.exactMatch.label, equals('بحث مطابق'));
      });
    });

    group('toQueryParam', () {
      test('should return ID for all methods', () {
        for (final method in SearchMethod.values) {
          expect(method.toQueryParam(), equals(method.id));
        }
      });

      test('should return correct query params', () {
        expect(SearchMethod.allWords.toQueryParam(), equals('w'));
        expect(SearchMethod.anyWord.toQueryParam(), equals('a'));
        expect(SearchMethod.exactMatch.toQueryParam(), equals('p'));
      });
    });

    group('toString', () {
      test('should return label', () {
        for (final method in SearchMethod.values) {
          expect(method.toString(), equals(method.label));
        }
      });

      test('should return Arabic labels', () {
        expect(SearchMethod.allWords.toString(), contains('جميع'));
        expect(SearchMethod.anyWord.toString(), contains('أي'));
        expect(SearchMethod.exactMatch.toString(), contains('مطابق'));
      });
    });

    group('fromId', () {
      test('should find method by valid ID', () {
        expect(SearchMethod.fromId('w'), equals(SearchMethod.allWords));
        expect(SearchMethod.fromId('a'), equals(SearchMethod.anyWord));
        expect(SearchMethod.fromId('p'), equals(SearchMethod.exactMatch));
      });

      test('should return null for invalid ID', () {
        expect(SearchMethod.fromId('z'), isNull);
        expect(SearchMethod.fromId('invalid'), isNull);
        expect(SearchMethod.fromId(''), isNull);
      });

      test('should be case-sensitive', () {
        expect(SearchMethod.fromId('W'), isNull); // Uppercase
        expect(SearchMethod.fromId('A'), isNull);
        expect(SearchMethod.fromId('P'), isNull);
      });
    });

    group('Enum ordering', () {
      test('should maintain logical order', () {
        expect(SearchMethod.values[0], equals(SearchMethod.allWords));
        expect(SearchMethod.values[1], equals(SearchMethod.anyWord));
        expect(SearchMethod.values[2], equals(SearchMethod.exactMatch));
      });
    });

    group('Usage in collections', () {
      test('should work in List', () {
        final methods = [SearchMethod.allWords, SearchMethod.exactMatch];

        expect(methods, hasLength(2));
        expect(methods, contains(SearchMethod.allWords));
      });

      test('should work in Set', () {
        final methods = {SearchMethod.allWords, SearchMethod.anyWord};

        expect(methods, hasLength(2));
      });

      test('should work as Map keys', () {
        final methodMap = {
          SearchMethod.allWords: 'AND search',
          SearchMethod.anyWord: 'OR search',
          SearchMethod.exactMatch: 'Exact phrase',
        };

        expect(methodMap[SearchMethod.allWords], equals('AND search'));
        expect(methodMap[SearchMethod.exactMatch], equals('Exact phrase'));
      });
    });

    group('Practical usage', () {
      test('allWords is default for strict matching', () {
        // Most restrictive - all words must match
        expect(SearchMethod.allWords.id, equals('w'));
      });

      test('anyWord is best for broad search', () {
        // Least restrictive - any word can match
        expect(SearchMethod.anyWord.id, equals('a'));
      });

      test('exactMatch for precise queries', () {
        // Exact phrase matching
        expect(SearchMethod.exactMatch.id, equals('p'));
      });
    });

    group('Equality', () {
      test('should be equal to itself', () {
        expect(SearchMethod.allWords, equals(SearchMethod.allWords));
      });

      test('should not be equal to different method', () {
        expect(SearchMethod.allWords, isNot(equals(SearchMethod.anyWord)));
      });

      test('should have consistent hashCode', () {
        final method1 = SearchMethod.allWords;
        final method2 = SearchMethod.allWords;

        expect(method1.hashCode, equals(method2.hashCode));
      });
    });

    group('Search behavior semantics', () {
      test('should have IDs matching API expectations', () {
        // Verify IDs match the original API
        expect(SearchMethod.allWords.id, equals('w')); // "words"
        expect(SearchMethod.anyWord.id, equals('a')); // "any"
        expect(SearchMethod.exactMatch.id, equals('p')); // "phrase"
      });
    });
  });
}
