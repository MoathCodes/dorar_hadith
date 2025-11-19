import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

/// Shared validators for integration tests that exercise real Dorar.net data.
///
/// These helpers focus on ensuring Arabic content stays intact and that core
/// models expose a complete structure when hydrated from live endpoints.
void verifyArabicText(String text, {String? name, bool allowEmpty = false}) {
  final label = name ?? 'Text';

  if (!allowEmpty) {
    expect(text.trim(), isNotEmpty, reason: '$label should not be empty');
  }

  expect(
    text,
    anyOf(isEmpty, contains(RegExp(r'[\u0600-\u06FF]'))),
    reason: '$label should contain Arabic characters when present',
  );

  expect(
    text,
    isNot(contains('�')),
    reason: '$label should not contain replacement characters',
  );
}

/// Verify that a [BookInfo] entry has its primary metadata populated.
void verifyBookInfoStructure(BookInfo book) {
  verifyArabicText(book.name, name: 'book.name');
  verifyArabicText(book.author, name: 'book.author');

  expect(
    book.bookId,
    isNotEmpty,
    reason: 'BookInfo.bookId should not be empty',
  );
  expect(
    book.publisher,
    isNotEmpty,
    reason: 'BookInfo.publisher should not be empty',
  );
}

/// Verify that a [Hadith] object includes the expected textual data.
void verifyHadithStructure(Hadith hadith) {
  verifyArabicText(hadith.hadith, name: 'hadith.hadith');
  verifyArabicText(hadith.rawi, name: 'hadith.rawi', allowEmpty: true);
  expect(hadith.grade, isNotEmpty, reason: 'Hadith.grade should not be empty');
  expect(hadith.book, isNotEmpty, reason: 'Hadith.book should not be empty');
  expect(
    hadith.numberOrPage,
    isNotEmpty,
    reason: 'Hadith.numberOrPage should not be empty',
  );

  String? takhrij;
  if (hadith is DetailedHadith) {
    takhrij = hadith.takhrij;

    if (hadith.hadithId != null) {
      expect(
        hadith.hadithId,
        isNotEmpty,
        reason: 'Hadith.hadithId should not be empty when provided',
      );
    }
  } else if (hadith is ExplainedHadith) {
    takhrij = hadith.takhrij;
  }

  final trimmedTakhrij = takhrij?.trim();
  if (trimmedTakhrij != null && trimmedTakhrij.isNotEmpty) {
    verifyArabicText(trimmedTakhrij, name: 'hadith.takhrij', allowEmpty: false);
  }
}

/// Verify that a [MohdithInfo] entry contains the expected fields.
void verifyMohdithInfoStructure(MohdithInfo mohdith) {
  verifyArabicText(mohdith.name, name: 'mohdith.name');
  verifyArabicText(mohdith.info, name: 'mohdith.info');

  expect(
    mohdith.mohdithId,
    isNotEmpty,
    reason: 'MohdithInfo.mohdithId should not be empty',
  );
}

/// Verify that a [Sharh] entry contains the core metadata required by clients.
void verifySharhStructure(Sharh sharh) {
  verifyArabicText(sharh.hadith.hadith, name: 'sharh.hadith');
  verifyArabicText(
    sharh.sharhMetadata?.sharh ?? '',
    name: 'sharh.sharh',
    allowEmpty: true,
  );
  verifyArabicText(sharh.hadith.mohdith, name: 'sharh.mohdith');
  verifyArabicText(sharh.hadith.rawi, name: 'sharh.rawi', allowEmpty: true);

  expect(
    sharh.hadith.book,
    isNotEmpty,
    reason: 'Sharh.book should not be empty',
  );
  expect(
    sharh.hadith.numberOrPage,
    isNotEmpty,
    reason: 'Sharh.numberOrPage should not be empty',
  );
}
