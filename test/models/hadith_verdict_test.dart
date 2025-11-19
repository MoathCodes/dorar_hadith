import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('Unified verdict getter', () {
    test('Hadith.verdict returns grade', () {
      const h = Hadith(
        hadith: 'متن',
        rawi: 'راوي',
        mohdith: 'محدث',
        book: 'كتاب',
        numberOrPage: '1',
        grade: 'صحيح',
      );
      expect(h.hukm, equals('صحيح'));
    });

    test('DetailedHadith.verdict prefers explainGrade when non-empty', () {
      const h1 = DetailedHadith(
        hadith: 'متن',
        rawi: 'راوي',
        mohdith: 'محدث',
        book: 'كتاب',
        numberOrPage: '1',
        grade: 'حسن',
        explainGrade: 'صحيح لغيره',
      );
      expect(h1.hukm, equals('صحيح لغيره'));

      const h2 = DetailedHadith(
        hadith: 'متن',
        rawi: 'راوي',
        mohdith: 'محدث',
        book: 'كتاب',
        numberOrPage: '1',
        grade: 'ضعيف',
        explainGrade: '',
      );
      expect(h2.hukm, equals('ضعيف'));

      const h3 = DetailedHadith(
        hadith: 'متن',
        rawi: 'راوي',
        mohdith: 'محدث',
        book: 'كتاب',
        numberOrPage: '1',
        grade: 'ضعيف',
        explainGrade: null,
      );
      expect(h3.hukm, equals('ضعيف'));
    });
  });
}
