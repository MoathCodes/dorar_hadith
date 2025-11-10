import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('Hadith Model', () {
    group('Constructor and Properties', () {
      test('should create hadith with required fields only', () {
        final hadith = const Hadith(
          hadith: 'إنما الأعمال بالنيات',
          rawi: 'عمر بن الخطاب',
          mohdith: 'البخاري',
          book: 'صحيح البخاري',
          numberOrPage: '1',
          grade: 'صحيح',
        );

        expect(hadith.hadith, equals('إنما الأعمال بالنيات'));
        expect(hadith.rawi, equals('عمر بن الخطاب'));
        expect(hadith.mohdith, equals('البخاري'));
        expect(hadith.book, equals('صحيح البخاري'));
        expect(hadith.numberOrPage, equals('1'));
        expect(hadith.grade, equals('صحيح'));
      });

      test('should create hadith with all fields', () {
        final metadata = SharhMetadata(
          id: '123',
          isContainSharh: true,
          sharh: 'Explanation text',
        );

        final hadith = Hadith(
          hadith: 'Test hadith',
          rawi: 'Test rawi',
          mohdith: 'Test mohdith',
          mohdithId: '1',
          book: 'Test book',
          bookId: '2',
          numberOrPage: '100',
          grade: 'صحيح',
          explainGrade: 'Detailed grade',
          takhrij: 'Takhrij info',
          hadithId: 'h123',
          hasSimilarHadith: true,
          hasAlternateHadithSahih: true,
          hasUsulHadith: true,
          similarHadithDorar: 'https://dorar.net/h/123?sims=1',
          alternateHadithSahihDorar: 'https://dorar.net/h/123?alts=1',
          usulHadithDorar: 'https://dorar.net/h/123?osoul=1',
          hasSharhMetadata: true,
          sharhMetadata: metadata,
        );

        expect(hadith.mohdithId, equals('1'));
        expect(hadith.bookId, equals('2'));
        expect(hadith.hadithId, equals('h123'));
        expect(hadith.hasSimilarHadith, isTrue);
        expect(hadith.hasSharhMetadata, isTrue);
        expect(hadith.sharhMetadata, equals(metadata));
      });

      test('should have correct default values for optional fields', () {
        const hadith = Hadith(
          hadith: 'Test',
          rawi: 'Test rawi',
          mohdith: 'Test mohdith',
          book: 'Test book',
          numberOrPage: '1',
          grade: 'صحيح',
        );

        expect(hadith.mohdithId, isNull);
        expect(hadith.bookId, isNull);
        expect(hadith.explainGrade, isNull);
        expect(hadith.takhrij, isNull);
        expect(hadith.hadithId, isNull);
        expect(hadith.hasSimilarHadith, isFalse);
        expect(hadith.hasAlternateHadithSahih, isFalse);
        expect(hadith.hasUsulHadith, isFalse);
        expect(hadith.hasSharhMetadata, isFalse);
        expect(hadith.sharhMetadata, isNull);
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const hadith = Hadith(
          hadith: 'Test hadith',
          rawi: 'Test rawi',
          mohdith: 'Test mohdith',
          book: 'Test book',
          numberOrPage: '1',
          grade: 'صحيح',
          hadithId: 'h123',
        );

        final json = hadith.toJson();

        expect(json['hadith'], equals('Test hadith'));
        expect(json['rawi'], equals('Test rawi'));
        expect(json['mohdith'], equals('Test mohdith'));
        expect(json['book'], equals('Test book'));
        expect(json['numberOrPage'], equals('1'));
        expect(json['grade'], equals('صحيح'));
        expect(json['hadithId'], equals('h123'));
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'hadith': 'Test hadith',
          'rawi': 'Test rawi',
          'mohdith': 'Test mohdith',
          'book': 'Test book',
          'numberOrPage': '1',
          'grade': 'صحيح',
          'mohdithId': '10',
          'bookId': '20',
          'hadithId': 'h123',
          'hasSimilarHadith': true,
        };

        final hadith = Hadith.fromJson(json);

        expect(hadith.hadith, equals('Test hadith'));
        expect(hadith.rawi, equals('Test rawi'));
        expect(hadith.mohdithId, equals('10'));
        expect(hadith.bookId, equals('20'));
        expect(hadith.hadithId, equals('h123'));
        expect(hadith.hasSimilarHadith, isTrue);
      });

      test('should handle null values in JSON', () {
        final json = {
          'hadith': 'Test',
          'rawi': 'Test rawi',
          'mohdith': 'Test mohdith',
          'book': 'Test book',
          'numberOrPage': '1',
          'grade': 'صحيح',
        };

        final hadith = Hadith.fromJson(json);

        expect(hadith.mohdithId, isNull);
        expect(hadith.explainGrade, isNull);
        expect(hadith.takhrij, isNull);
      });

      test('should round-trip through JSON', () {
        const original = Hadith(
          hadith: 'Test hadith',
          rawi: 'Test rawi',
          mohdith: 'Test mohdith',
          mohdithId: '5',
          book: 'Test book',
          bookId: '10',
          numberOrPage: '100',
          grade: 'صحيح',
          hadithId: 'h999',
        );

        final json = original.toJson();
        final restored = Hadith.fromJson(json);

        expect(restored.hadith, equals(original.hadith));
        expect(restored.rawi, equals(original.rawi));
        expect(restored.mohdithId, equals(original.mohdithId));
        expect(restored.bookId, equals(original.bookId));
        expect(restored.hadithId, equals(original.hadithId));
      });
    });

    group('Equality and HashCode', () {
      test('should be equal when all fields match', () {
        const hadith1 = Hadith(
          hadith: 'Test',
          rawi: 'Rawi',
          mohdith: 'Mohdith',
          book: 'Book',
          numberOrPage: '1',
          grade: 'صحيح',
        );

        const hadith2 = Hadith(
          hadith: 'Test',
          rawi: 'Rawi',
          mohdith: 'Mohdith',
          book: 'Book',
          numberOrPage: '1',
          grade: 'صحيح',
        );

        expect(hadith1, equals(hadith2));
        expect(hadith1.hashCode, equals(hadith2.hashCode));
      });

      test('should not be equal when hadith text differs', () {
        const hadith1 = Hadith(
          hadith: 'Test 1',
          rawi: 'Rawi',
          mohdith: 'Mohdith',
          book: 'Book',
          numberOrPage: '1',
          grade: 'صحيح',
        );

        const hadith2 = Hadith(
          hadith: 'Test 2',
          rawi: 'Rawi',
          mohdith: 'Mohdith',
          book: 'Book',
          numberOrPage: '1',
          grade: 'صحيح',
        );

        expect(hadith1, isNot(equals(hadith2)));
      });

      test('should not be equal when optional fields differ', () {
        const hadith1 = Hadith(
          hadith: 'Test',
          rawi: 'Rawi',
          mohdith: 'Mohdith',
          book: 'Book',
          numberOrPage: '1',
          grade: 'صحيح',
          hadithId: 'h1',
        );

        const hadith2 = Hadith(
          hadith: 'Test',
          rawi: 'Rawi',
          mohdith: 'Mohdith',
          book: 'Book',
          numberOrPage: '1',
          grade: 'صحيح',
          hadithId: 'h2',
        );

        expect(hadith1, isNot(equals(hadith2)));
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () {
        const hadith = Hadith(
          hadith: '',
          rawi: '',
          mohdith: '',
          book: '',
          numberOrPage: '',
          grade: '',
        );

        expect(hadith.hadith, equals(''));
        expect(hadith.rawi, equals(''));
      });

      test('should handle very long text', () {
        final longText = 'A' * 10000;
        final hadith = Hadith(
          hadith: longText,
          rawi: 'Test',
          mohdith: 'Test',
          book: 'Test',
          numberOrPage: '1',
          grade: 'صحيح',
        );

        expect(hadith.hadith.length, equals(10000));
      });

      test('should handle Arabic text correctly', () {
        const hadith = Hadith(
          hadith: 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
          rawi: 'عُمَرَ بْنِ الْخَطَّابِ',
          mohdith: 'البُخَارِيُّ',
          book: 'صَحِيحُ البُخَارِيِّ',
          numberOrPage: '١',
          grade: 'صَحِيحٌ',
        );

        expect(hadith.hadith, contains('إِنَّمَا'));
        expect(hadith.rawi, contains('عُمَرَ'));
      });
    });
  });
}
