import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('HadithSearchParams', () {
    test('should create with required parameters only', () {
      const params = HadithSearchParams(value: 'الصلاة');

      expect(params.value, equals('الصلاة'));
      expect(params.page, equals(1));
      expect(params.removeHtml, isTrue);
      expect(params.specialist, isFalse);
      expect(params.exclude, isNull);
      expect(params.searchMethod, isNull);
      expect(params.zone, isNull);
      expect(params.degrees, isNull);
      expect(params.mohdith, isNull);
      expect(params.books, isNull);
      expect(params.rawi, isNull);
    });

    test('should create with all parameters', () {
      final params = HadithSearchParams(
        value: 'الصيام',
        page: 5,
        removeHtml: false,
        specialist: true,
        exclude: 'مكذوب',
        searchMethod: SearchMethod.exactMatch,
        zone: SearchZone.marfoo,
        degrees: [HadithDegree.authenticHadith, HadithDegree.authenticChain],
        mohdith: [MohdithReference.bukhari],
        books: [BookReference.sahihBukhari],
        rawi: [RawiReference.abuHurayrah],
      );

      expect(params.value, equals('الصيام'));
      expect(params.page, equals(5));
      expect(params.removeHtml, isFalse);
      expect(params.specialist, isTrue);
      expect(params.exclude, equals('مكذوب'));
      expect(params.searchMethod, equals(SearchMethod.exactMatch));
      expect(params.zone, equals(SearchZone.marfoo));
      expect(params.degrees, hasLength(2));
      expect(params.mohdith, contains(MohdithReference.bukhari));
      expect(params.books, contains(BookReference.sahihBukhari));
      expect(params.rawi, contains(RawiReference.abuHurayrah));
    });

    test('should handle copyWith correctly', () {
      const original = HadithSearchParams(
        value: 'original',
        page: 1,
        removeHtml: true,
      );

      final copied = original.copyWith(value: 'modified', page: 5);

      expect(copied.value, equals('modified'));
      expect(copied.page, equals(5));
      expect(copied.removeHtml, isTrue); // Unchanged
    });

    test('should handle copyWith with null parameters', () {
      const original = HadithSearchParams(
        value: 'test',
        page: 3,
        specialist: true,
      );

      final copied = original.copyWith();

      expect(copied.value, equals(original.value));
      expect(copied.page, equals(original.page));
      expect(copied.specialist, equals(original.specialist));
    });

    test('should have correct toString representation', () {
      const params = HadithSearchParams(value: 'الصلاة', page: 2);
      final str = params.toString();

      expect(str, contains('HadithSearchParams'));
      expect(str, contains('الصلاة'));
      expect(str, contains('2'));
    });
  });
}
