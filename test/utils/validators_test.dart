import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('Validators', () {
    group('validateSearchText()', () {
      test('should accept valid search text', () {
        expect(() => Validators.validateSearchText('الصلاة'), returnsNormally);
        expect(
          () => Validators.validateSearchText('test search'),
          returnsNormally,
        );
        expect(() => Validators.validateSearchText('a'), returnsNormally);
      });

      test('should throw DorarValidationException for empty text', () {
        expect(
          () => Validators.validateSearchText(''),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.field,
              'field',
              'value',
            ),
          ),
        );

        expect(
          () => Validators.validateSearchText('   '),
          throwsA(isA<DorarValidationException>()),
        );
      });

      test(
        'should throw DorarValidationException for text exceeding max length',
        () {
          final longText = 'a' * 501;
          expect(
            () => Validators.validateSearchText(longText),
            throwsA(
              isA<DorarValidationException>().having(
                (e) => e.rule,
                'rule',
                'maxLength',
              ),
            ),
          );
        },
      );

      test('should accept text at exactly max length (500)', () {
        final maxText = 'a' * 500;
        expect(() => Validators.validateSearchText(maxText), returnsNormally);
      });
    });

    group('validatePage()', () {
      test('should accept valid page numbers', () {
        expect(() => Validators.validatePage(1), returnsNormally);
        expect(() => Validators.validatePage(50), returnsNormally);
        expect(() => Validators.validatePage(1000), returnsNormally);
      });

      test('should throw DorarValidationException for page < 1', () {
        expect(
          () => Validators.validatePage(0),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.field,
              'field',
              'page',
            ),
          ),
        );

        expect(
          () => Validators.validatePage(-1),
          throwsA(isA<DorarValidationException>()),
        );
      });

      test('should throw DorarValidationException for page > 1000', () {
        expect(
          () => Validators.validatePage(1001),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.rule,
              'rule',
              'max',
            ),
          ),
        );
      });
    });

    group('validateHadithId()', () {
      test('should return trimmed ID for valid input', () {
        expect(Validators.validateHadithId('  h123  '), equals('h123'));
        expect(Validators.validateHadithId('abc_123'), equals('abc_123'));
        expect(Validators.validateHadithId('test-id'), equals('test-id'));
      });

      test('should throw DorarValidationException for empty ID', () {
        expect(
          () => Validators.validateHadithId(''),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.field,
              'field',
              'hadithId',
            ),
          ),
        );
      });

      test('should accept alphanumeric with hyphens and underscores', () {
        expect(Validators.validateHadithId('abc-123'), equals('abc-123'));
        expect(Validators.validateHadithId('j0j8uiR3'), equals('j0j8uiR3'));
        expect(Validators.validateHadithId('BRpyQaPP'), equals('BRpyQaPP'));
        expect(Validators.validateHadithId('i9N1PTUu'), equals('i9N1PTUu'));
      });

      test('should reject invalid characters in hadith IDs', () {
        expect(
          () => Validators.validateHadithId('abc@123'),
          throwsA(isA<DorarValidationException>()),
        );
        expect(
          () => Validators.validateHadithId('test id'),
          throwsA(isA<DorarValidationException>()),
        );
        expect(
          () => Validators.validateHadithId('abc/123'),
          throwsA(isA<DorarValidationException>()),
        );
        expect(
          () => Validators.validateHadithId('1.06'),
          throwsA(isA<DorarValidationException>()),
        );
      });
    });

    group('validateSharhId()', () {
      test('should accept valid sharh IDs', () {
        expect(() => Validators.validateSharhId('12345'), returnsNormally);
        expect(() => Validators.validateSharhId('1'), returnsNormally);
      });

      test('should throw DorarValidationException for empty ID', () {
        expect(
          () => Validators.validateSharhId(''),
          throwsA(isA<DorarValidationException>()),
        );
      });

      test('should throw DorarValidationException for non-numeric ID', () {
        expect(
          () => Validators.validateSharhId('abc'),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.rule,
              'rule',
              'numeric',
            ),
          ),
        );

        expect(
          () => Validators.validateSharhId('123abc'),
          throwsA(isA<DorarValidationException>()),
        );
      });
    });

    group('validateBookId()', () {
      test('should accept valid book IDs', () {
        expect(() => Validators.validateBookId('999'), returnsNormally);
        expect(() => Validators.validateBookId('1'), returnsNormally);
      });

      test('should throw DorarValidationException for empty ID', () {
        expect(
          () => Validators.validateBookId(''),
          throwsA(isA<DorarValidationException>()),
        );
      });

      test('should throw DorarValidationException for non-numeric ID', () {
        expect(
          () => Validators.validateBookId('abc'),
          throwsA(isA<DorarValidationException>()),
        );
      });
    });

    group('validateMohdithId()', () {
      test('should accept valid mohdith IDs', () {
        expect(() => Validators.validateMohdithId('500'), returnsNormally);
        expect(() => Validators.validateMohdithId('1'), returnsNormally);
      });

      test('should throw DorarValidationException for empty ID', () {
        expect(
          () => Validators.validateMohdithId(''),
          throwsA(isA<DorarValidationException>()),
        );
      });

      test('should throw DorarValidationException for non-numeric ID', () {
        expect(
          () => Validators.validateMohdithId('abc'),
          throwsA(isA<DorarValidationException>()),
        );
      });
    });

    group('validateUrl()', () {
      test('should accept valid URLs', () {
        expect(
          () => Validators.validateUrl('https://dorar.net'),
          returnsNormally,
        );
        expect(
          () => Validators.validateUrl('http://example.com/path'),
          returnsNormally,
        );
        expect(
          () =>
              Validators.validateUrl('https://api.example.com/v1/data?q=test'),
          returnsNormally,
        );
      });

      test('should throw DorarValidationException for empty URL', () {
        expect(
          () => Validators.validateUrl(''),
          throwsA(isA<DorarValidationException>()),
        );
      });

      test('should throw DorarValidationException for invalid scheme', () {
        expect(
          () => Validators.validateUrl('ftp://example.com'),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.rule,
              'rule',
              'format',
            ),
          ),
        );

        expect(
          () => Validators.validateUrl('example.com'),
          throwsA(isA<DorarValidationException>()),
        );

        expect(
          () => Validators.validateUrl('not a url'),
          throwsA(isA<DorarValidationException>()),
        );
      });
    });

    group('validateTimeout()', () {
      test('should accept valid timeout durations', () {
        expect(
          () => Validators.validateTimeout(const Duration(seconds: 1)),
          returnsNormally,
        );
        expect(
          () => Validators.validateTimeout(const Duration(seconds: 15)),
          returnsNormally,
        );
        expect(
          () => Validators.validateTimeout(const Duration(seconds: 300)),
          returnsNormally,
        );
      });

      test('should throw DorarValidationException for zero duration', () {
        expect(
          () => Validators.validateTimeout(Duration.zero),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.field,
              'field',
              'timeout',
            ),
          ),
        );
      });

      test('should throw DorarValidationException for negative duration', () {
        expect(
          () => Validators.validateTimeout(const Duration(seconds: -1)),
          throwsA(isA<DorarValidationException>()),
        );
      });

      test('should throw DorarValidationException for duration > 300s', () {
        expect(
          () => Validators.validateTimeout(const Duration(seconds: 301)),
          throwsA(
            isA<DorarValidationException>().having(
              (e) => e.rule,
              'rule',
              'max',
            ),
          ),
        );
      });
    });
  });
}
