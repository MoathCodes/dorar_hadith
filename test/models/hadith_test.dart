import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('DetailedHadith', () {
    test('constructor applies required fields and default flag values', () {
      const hadith = DetailedHadith(
        hadith: 'إنما الأعمال بالنيات',
        rawi: 'عمر بن الخطاب',
        mohdith: 'البخاري',
        book: 'صحيح البخاري',
        numberOrPage: '1',
        grade: 'صحيح',
      );

      expect(hadith.hadith, 'إنما الأعمال بالنيات');
      expect(hadith.rawi, 'عمر بن الخطاب');
      expect(hadith.mohdith, 'البخاري');
      expect(hadith.book, 'صحيح البخاري');
      expect(hadith.numberOrPage, '1');
      expect(hadith.grade, 'صحيح');
      expect(hadith.hadithId, isNull);
      expect(hadith.hasSimilarHadith, isFalse);
      expect(hadith.hasAlternateHadithSahih, isFalse);
      expect(hadith.hasUsulHadith, isFalse);
      expect(hadith.hasSharhMetadata, isFalse);
      expect(hadith.sharhMetadata, isNull);
    });

    test('constructor supports optional metadata toggles', () {
      final metadata = SharhMetadata(
        id: '99',
        isContainSharh: true,
        sharh: 'شرح',
      );
      final hadith = DetailedHadith(
        hadith: 'حديث الاختيارات',
        rawi: 'راوي',
        mohdith: 'محدث',
        mohdithId: '10',
        book: 'كتاب',
        bookId: '20',
        numberOrPage: '42',
        grade: 'حسن',
        explainGrade: 'توضيح',
        takhrij: 'تخريج',
        hadithId: 'h42',
        hasSimilarHadith: true,
        hasAlternateHadithSahih: true,
        hasUsulHadith: true,
        similarHadithDorar: 'https://dorar.net/h/42?sims=1',
        alternateHadithSahihDorar: 'https://dorar.net/h/42?alts=1',
        usulHadithDorar: 'https://dorar.net/h/42?osoul=1',
        hasSharhMetadata: true,
        sharhMetadata: metadata,
      );

      expect(hadith.hadithId, 'h42');
      expect(hadith.hasSimilarHadith, isTrue);
      expect(hadith.similarHadithDorar, contains('sims=1'));
      expect(hadith.hasAlternateHadithSahih, isTrue);
      expect(hadith.hasUsulHadith, isTrue);
      expect(hadith.hasSharhMetadata, isTrue);
      expect(hadith.sharhMetadata, equals(metadata));
      expect(hadith.explainGrade, 'توضيح');
      expect(hadith.takhrij, 'تخريج');
    });

    test('fromJson parses optional identifiers and boolean flags', () {
      final hadith = DetailedHadith.fromJson({
        'hadith': 'نص الحديث',
        'rawi': 'الراوي',
        'mohdith': 'المحدث',
        'mohdithId': '7',
        'book': 'الكتاب',
        'bookId': '88',
        'numberOrPage': '15',
        'grade': 'صحيح',
        'explainGrade': 'شرح التقييم',
        'takhrij': 'تخريج مفصل',
        'hadithId': 'h15',
        'hasSimilarHadith': true,
        'hasAlternateHadithSahih': true,
        'hasUsulHadith': false,
        'similarHadithDorar': 'https://example.com/similar',
        'alternateHadithSahihDorar': 'https://example.com/alternate',
        'usulHadithDorar': null,
      });

      expect(hadith.mohdithId, '7');
      expect(hadith.bookId, '88');
      expect(hadith.hadithId, 'h15');
      expect(hadith.hasSimilarHadith, isTrue);
      expect(hadith.hasAlternateHadithSahih, isTrue);
      expect(hadith.hasUsulHadith, isFalse);
      expect(hadith.similarHadithDorar, contains('similar'));
    });

    test('round-trip JSON maintains core fields', () {
      final original = DetailedHadith(
        hadith: 'متن الحديث',
        rawi: 'أبو هريرة',
        mohdith: 'مسلم',
        mohdithId: '5',
        book: 'صحيح مسلم',
        bookId: '2582',
        numberOrPage: '123',
        grade: 'صحيح',
        hadithId: 'h123',
        hasSimilarHadith: true,
      );

      final restored = DetailedHadith.fromJson(original.toJson());

      expect(restored.hadith, original.hadith);
      expect(restored.rawi, original.rawi);
      expect(restored.mohdith, original.mohdith);
      expect(restored.bookId, original.bookId);
      expect(restored.hadithId, original.hadithId);
      expect(restored.hasSimilarHadith, original.hasSimilarHadith);
    });
  });
}
