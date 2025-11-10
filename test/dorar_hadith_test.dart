import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('DorarClient Integration', () {
    test('package exports DorarClient', () {
      // Verify the main client is exported
      expect(DorarClient, isNotNull);
    });

    test('package exports all models', () {
      // Verify key models are exported
      expect(Hadith, isNotNull);
      expect(Sharh, isNotNull);
      expect(ApiResponse, isNotNull);
      expect(HadithSearchParams, isNotNull);
    });

    test('package exports all enums', () {
      // Verify enums are exported
      expect(HadithDegree.values, isNotEmpty);
      expect(SearchMethod.values, isNotEmpty);
      expect(SearchZone.values, isNotEmpty);
    });

    test('package exports all exceptions', () {
      // Verify exceptions are exported
      expect(DorarException, isNotNull);
      expect(DorarNetworkException, isNotNull);
      expect(DorarValidationException, isNotNull);
    });
  });
}
