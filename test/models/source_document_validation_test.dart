import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  test(
    'persisted documents reject stale text hashes and incompatible schemas',
    () {
      final document = DocumentParser.parse('<p>قال 😀</p>');
      expect(SourcedDocument.fromJson(document.toJson()), document);
      for (final changed in [
        {...document.toJson(), 'sourceText': 'changed'},
        {...document.toJson(), 'schemaVersion': 99},
        {
          ...document.toJson(),
          'annotations': [
            {
              'kind': 'link',
              'range': {'start': 5, 'end': 6},
            },
          ],
        },
        {
          ...document.toJson(),
          'blocks': [
            {
              'kind': 'paragraph',
              'range': {'start': 0, 'end': 100},
            },
          ],
        },
      ]) {
        expect(() => SourcedDocument.fromJson(changed), throwsFormatException);
      }
    },
  );
  test('rendering rejects invalid programmatically constructed documents', () {
    final valid = DocumentParser.parse('قال 😀');
    final invalid = SourcedDocument(
      sourceHtml: valid.sourceHtml,
      sourceText: valid.sourceText,
      contentHash: valid.contentHash,
      blocks: const [
        DocumentBlock(kind: BlockKind.paragraph, range: TextRange(5, 6)),
      ],
    );
    expect(() => documentRenderTokens(invalid), throwsFormatException);
    expect(() => renderDocumentHtml(invalid), throwsFormatException);
    expect(() => invalid.commentaryText, throwsFormatException);
  });
  test(
    'edition component raw values retain original Arabic digits and bidi marks',
    () {
      const raw = '\u200f١٤٢٣هـ / ٢٠٠٢ميلادية';
      final date = EditionDate.parse(raw);
      expect(date.raw, raw);
      expect(date.status, DateParseStatus.parsed);
      expect(date.components.map((c) => c.year), [1423, 2002]);
      expect(date.components.map((c) => c.raw), ['١٤٢٣هـ', '٢٠٠٢ميلادية']);
      expect(date.components.map((c) => c.calendar), [
        CalendarKind.hijri,
        CalendarKind.gregorian,
      ]);
      expect(
        EditionDate.parse('١٤\u200f٢٣هجرية').components.single.raw,
        '١٤\u200f٢٣هجرية',
      );
    },
  );
  test('Quran citation coordinates come only from explicit labels', () {
    final document = DocumentParser.parse(
      '<p><a href="/tafseer/107/1">[الماعون: 4، 5]</a><a href="/tafseer/31/5">[لقمان: 14]</a><a href="/tafseer/2/10">لفظ غير محدد</a></p>',
    );
    final refs = document.annotations.map((a) => a.quranReference!).toList();
    expect(refs[0].surahName, 'الماعون');
    expect(refs[0].surahNumber, isNull);
    expect(refs[0].ayahNumbers, [4, 5]);
    expect(refs[1].ayahNumbers, [14]);
    expect(refs[1].surahNumber, isNull);
    expect(refs[2].status, LocatorParseStatus.unparsed);
    expect(refs[2].ayahNumbers, isEmpty);
    expect(QuranCitationReference.parseLabel('[لقمان: ١٤]').ayahNumbers, [14]);
    expect(
      QuranCitationReference.parseLabel('[لقمان: 9999]').status,
      LocatorParseStatus.unparsed,
    );
  });
}
