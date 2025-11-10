import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('normalizeArabicSearch', () {
    test('removes common diacritics and normalizes letters', () {
      expect(normalizeArabicSearch('مُحَمَّد'), 'محمد');
      expect(normalizeArabicSearch('إبراهيم'), 'ابراهيم');
      expect(normalizeArabicSearch('على'), 'علي');
      expect(normalizeArabicSearch('رحمة'), 'رحمه');
    });
  });

  group('fuzzyMatch', () {
    test('matches text ignoring diacritics and letter variants', () {
      expect(fuzzyMatch('أبو هُرَيْرَة', 'ابو هريره'), isTrue);
      expect(fuzzyMatch('محمد بن عبدالله', 'محمد'), isTrue);
      expect(fuzzyMatch('علي بن أبي طالب', 'عثمان'), isFalse);
    });
  });

  group('similarityScore', () {
    test('returns 1.0 for identical phrases', () {
      expect(similarityScore('محمد', 'محمد'), 1.0);
    });

    test('returns value between 0 and 1 for partial matches', () {
      final score = similarityScore('أبو بكر الصديق', 'ابو بكر');
      expect(score, inInclusiveRange(0.5, 0.99));
    });

    test('returns 0.0 for completely different phrases', () {
      expect(similarityScore('علي', 'عثمان'), 0.0);
    });
  });
}
