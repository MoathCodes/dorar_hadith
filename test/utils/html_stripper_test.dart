import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('HtmlUtils', () {
    group('stripHtml()', () {
      test('should remove HTML tags', () {
        expect(
          HtmlUtils.stripHtml('<p>Hello <b>World</b></p>'),
          equals('Hello World'),
        );

        expect(
          HtmlUtils.stripHtml('<div><span>Test</span></div>'),
          equals('Test'),
        );
      });

      test('should handle self-closing tags', () {
        expect(HtmlUtils.stripHtml('Line 1<br/>Line 2'), contains('Line 1'));
      });

      test('should handle nested tags', () {
        expect(
          HtmlUtils.stripHtml(
            '<div><p><span><strong>Text</strong></span></p></div>',
          ),
          equals('Text'),
        );
      });

      test('should decode HTML entities', () {
        expect(
          HtmlUtils.stripHtml('Hello&nbsp;World&amp;Universe'),
          equals('Hello World&Universe'),
        );
      });

      test('should handle empty input', () {
        expect(HtmlUtils.stripHtml(''), equals(''));
      });

      test('should handle text without HTML', () {
        expect(HtmlUtils.stripHtml('Plain text'), equals('Plain text'));
      });
    });

    group('decodeHtmlEntities()', () {
      test('should decode named entities', () {
        expect(HtmlUtils.decodeHtmlEntities('&nbsp;'), equals(' '));
        expect(HtmlUtils.decodeHtmlEntities('&lt;'), equals('<'));
        expect(HtmlUtils.decodeHtmlEntities('&gt;'), equals('>'));
        expect(HtmlUtils.decodeHtmlEntities('&amp;'), equals('&'));
        expect(HtmlUtils.decodeHtmlEntities('&quot;'), equals('"'));
      });

      test('should decode decimal numeric entities', () {
        expect(HtmlUtils.decodeHtmlEntities('&#65;'), equals('A'));
        expect(
          HtmlUtils.decodeHtmlEntities('&#1575;'),
          equals('ا'),
        ); // Arabic Alef
      });

      test('should decode hexadecimal numeric entities', () {
        expect(HtmlUtils.decodeHtmlEntities('&#x41;'), equals('A'));
        expect(
          HtmlUtils.decodeHtmlEntities('&#x0627;'),
          equals('ا'),
        ); // Arabic Alef
      });

      test('should handle multiple entities', () {
        expect(
          HtmlUtils.decodeHtmlEntities(
            '&lt;div&gt;Hello&nbsp;World&lt;/div&gt;',
          ),
          equals('<div>Hello World</div>'),
        );
      });

      test('should handle empty input', () {
        expect(HtmlUtils.decodeHtmlEntities(''), equals(''));
      });

      test('should leave unrecognized entities unchanged', () {
        expect(
          HtmlUtils.decodeHtmlEntities('&unknownEntity;'),
          contains('&unknownEntity;'),
        );
      });
    });

    group('cleanWhitespace()', () {
      test('should replace multiple spaces with single space', () {
        expect(
          HtmlUtils.cleanWhitespace('Hello    World'),
          equals('Hello World'),
        );
        expect(HtmlUtils.cleanWhitespace('A  B  C'), equals('A B C'));
      });

      test('should trim leading and trailing whitespace', () {
        expect(HtmlUtils.cleanWhitespace('  Hello  '), equals('Hello'));
        expect(HtmlUtils.cleanWhitespace('\n\nTest\n\n'), equals('Test'));
      });

      test('should normalize line breaks', () {
        // The regex \s+ matches ALL whitespace including newlines
        // so multiple newlines become a single space
        expect(
          HtmlUtils.cleanWhitespace('Line1\n\n\n\nLine2'),
          equals('Line1 Line2'),
        );
      });

      test('should handle tabs and mixed whitespace', () {
        expect(
          HtmlUtils.cleanWhitespace('Hello\t\tWorld'),
          equals('Hello World'),
        );
      });

      test('should handle empty input', () {
        expect(HtmlUtils.cleanWhitespace(''), equals(''));
        expect(HtmlUtils.cleanWhitespace('   '), equals(''));
      });
    });

    group('cleanArabicText()', () {
      test('should remove diacritics when requested', () {
        final textWithDiacritics = 'الصَّلاَةُ';
        final cleaned = HtmlUtils.cleanArabicText(
          textWithDiacritics,
          removeDiacritics: true,
        );

        expect(cleaned, isNot(contains('َ'))); // Fatha
        expect(cleaned, isNot(contains('ُ'))); // Damma
        expect(cleaned, isNot(contains('ّ'))); // Shadda
      });

      test('should preserve diacritics when not requested', () {
        final textWithDiacritics = 'الصَّلاَةُ';
        final cleaned = HtmlUtils.cleanArabicText(
          textWithDiacritics,
          removeDiacritics: false,
        );

        expect(cleaned, isNotEmpty);
      });

      test('should normalize different forms of Alef', () {
        expect(HtmlUtils.cleanArabicText('أ'), equals('ا'));
        expect(HtmlUtils.cleanArabicText('إ'), equals('ا'));
        expect(HtmlUtils.cleanArabicText('آ'), equals('ا'));
      });

      test('should normalize Ta Marbuta', () {
        expect(HtmlUtils.cleanArabicText('ة'), equals('ه'));
      });

      test('should normalize Hamza variants', () {
        expect(HtmlUtils.cleanArabicText('ؤ'), equals('و'));
        expect(HtmlUtils.cleanArabicText('ئ'), equals('ي'));
      });

      test('should handle empty input', () {
        expect(HtmlUtils.cleanArabicText(''), equals(''));
      });
    });

    group('extractText()', () {
      test('should preserve paragraph breaks', () {
        final html = '<p>Para 1</p><p>Para 2</p>';
        final text = HtmlUtils.extractText(html);

        expect(text, contains('Para 1'));
        expect(text, contains('Para 2'));
      });

      test('should handle complex HTML structure', () {
        final html = '''
          <div>
            <h1>Title</h1>
            <p>Paragraph 1</p>
            <ul>
              <li>Item 1</li>
              <li>Item 2</li>
            </ul>
          </div>
        ''';

        final text = HtmlUtils.extractText(html);

        expect(text, contains('Title'));
        expect(text, contains('Paragraph 1'));
        expect(text, contains('Item 1'));
        expect(text, contains('Item 2'));
      });

      test('should handle empty input', () {
        expect(HtmlUtils.extractText(''), equals(''));
      });
    });

    group('containsHtml()', () {
      test('should detect HTML tags', () {
        expect(HtmlUtils.containsHtml('<div>Test</div>'), isTrue);
        expect(HtmlUtils.containsHtml('Hello <b>World</b>'), isTrue);
        expect(HtmlUtils.containsHtml('<br/>'), isTrue);
      });

      test('should return false for plain text', () {
        expect(HtmlUtils.containsHtml('Plain text'), isFalse);
        expect(HtmlUtils.containsHtml('No tags here'), isFalse);
        expect(HtmlUtils.containsHtml(''), isFalse);
      });

      test('should handle edge cases', () {
        expect(HtmlUtils.containsHtml('5 < 10'), isFalse); // Not a tag
        expect(HtmlUtils.containsHtml('A & B'), isFalse); // Entity, not tag
      });
    });

    group('truncate()', () {
      test('should truncate text to specified length', () {
        final text = 'This is a very long text that needs truncating';
        final truncated = HtmlUtils.truncate(text, 20);

        expect(truncated.length, lessThanOrEqualTo(20));
        expect(truncated, endsWith('...'));
      });

      test('should break at word boundaries', () {
        final text = 'This is a test sentence';
        final truncated = HtmlUtils.truncate(text, 10);

        expect(truncated, isNot(contains('tes'))); // Shouldn't break mid-word
      });

      test('should not truncate if text is shorter than max length', () {
        final text = 'Short text';
        final truncated = HtmlUtils.truncate(text, 50);

        expect(truncated, equals(text));
        expect(truncated, isNot(endsWith('...')));
      });

      test('should support custom ellipsis', () {
        final text = 'This is a long text';
        final truncated = HtmlUtils.truncate(text, 10, ellipsis: '…');

        expect(truncated, endsWith('…'));
      });

      test('should handle empty input', () {
        expect(HtmlUtils.truncate('', 10), equals(''));
      });

      test('should handle exact length match', () {
        final text = 'Exact match!';
        final truncated = HtmlUtils.truncate(text, text.length);

        expect(truncated, equals(text));
      });
    });

    group('Integration Tests', () {
      test('should handle complex Arabic HTML', () {
        final html = '''
          <div class="hadith">
            <p>قال رسول الله ﷺ: <strong>الصَّلاَةُ عِمَادُ الدِّينِ</strong></p>
            <span>الراوي: أبو هريرة</span>
          </div>
        ''';

        final text = HtmlUtils.stripHtml(html);

        expect(text, contains('قال رسول الله'));
        expect(
          text,
          contains('الصَّلاَةُ'),
        ); // Preserves original Arabic with diacritics
        expect(text, contains('أبو هريرة'));
      });

      test('should chain operations', () {
        final html = '<p>Hello&nbsp;&nbsp;&nbsp;World</p>';

        final result = HtmlUtils.cleanWhitespace(HtmlUtils.stripHtml(html));

        expect(result, equals('Hello World'));
      });

      test('should handle mixed content', () {
        final html = '''
          <div>
            Text with &lt;tags&gt; and entities: &amp; &nbsp;
            <span>More text</span>
          </div>
        ''';

        final text = HtmlUtils.stripHtml(html);

        expect(text, contains('<tags>'));
        expect(text, contains('&'));
        expect(text, contains('More text'));
      });
    });
  });
}
