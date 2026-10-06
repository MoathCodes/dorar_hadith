import 'package:dorar_hadith/src/parsers/hadith_parser.dart';
import 'package:test/test.dart';

void main() {
  group('HadithParser.cleanHadithText', () {
    test('search mode strips numbering but keeps mid-text dashes', () {
      const input = '1 - إنما الأعمال بالنيات - رواه البخاري';
      final cleaned = HadithParser.cleanHadithText(
        input,
        HadithTextCleanMode.search,
      );
      expect(cleaned, 'إنما الأعمال بالنيات - رواه البخاري');
    });

    test('detail mode strips dash prefixes but not numbering alone', () {
      const input = '- : إنما الأعمال بالنيات - رواه البخاري';
      final cleaned = HadithParser.cleanHadithText(
        input,
        HadithTextCleanMode.detail,
      );
      expect(cleaned, 'إنما الأعمال بالنيات - رواه البخاري');
    });

    test('search mode requires whitespace before dash after digits', () {
      const input = '12-without-space stays';
      final cleaned = HadithParser.cleanHadithText(
        input,
        HadithTextCleanMode.search,
      );
      expect(cleaned, '12-without-space stays');
    });
  });
}
