import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('Sharh pass-throughs', () {
    test('exposes sharh text and hadith fields', () {
      const explained = ExplainedHadith(
        hadith: 'إنما الأعمال بالنيات',
        rawi: 'عمر بن الخطاب',
        mohdith: 'البخاري',
        book: 'صحيح البخاري',
        numberOrPage: '1',
        grade: 'صحيح',
        takhrij: 'أخرجه البخاري ومسلم',
        hasSharhMetadata: true,
      );

      final sharh = Sharh(
        hadith: explained,
        sharhMetadata: const SharhMetadata(
          id: '99',
          isContainSharh: true,
          sharh: 'شرح مختصر',
        ),
      );

      // Sharh text alias
      expect(sharh.sharhText, equals('شرح مختصر'));
      expect(sharh.text, equals('شرح مختصر'));

      // Pass-throughs
      expect(sharh.hadithText, equals('إنما الأعمال بالنيات'));
      expect(sharh.rawi, equals('عمر بن الخطاب'));
      expect(sharh.mohdith, equals('البخاري'));
      expect(sharh.book, equals('صحيح البخاري'));
      expect(sharh.numberOrPage, equals('1'));
      expect(sharh.grade, equals('صحيح'));
      expect(sharh.verdict, equals('صحيح'));
      expect(sharh.takhrij, equals('أخرجه البخاري ومسلم'));
    });
  });
}
