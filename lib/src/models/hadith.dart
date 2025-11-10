import 'sharh_metadata.dart';

/// Represents a hadith with all its associated information.
class Hadith {
  /// The text of the hadith
  final String hadith;

  /// The narrator/transmitter (rawi)
  final String rawi;

  /// The scholar who authenticated it (mohdith)
  final String mohdith;

  /// ID of the mohdith
  final String? mohdithId;

  /// The book/source this hadith is from
  final String book;

  /// ID of the book
  final String? bookId;

  /// Page number or hadith number in the source
  final String numberOrPage;

  /// Grade/ruling of the hadith (sahih, daif, etc.)
  final String grade;

  /// Detailed explanation of the grade
  final String? explainGrade;

  /// Takhrij (other sources this hadith appears in)
  final String? takhrij;

  /// Unique identifier for this hadith
  final String? hadithId;

  /// Whether this hadith has similar narrations
  final bool hasSimilarHadith;

  /// Whether there's an alternate authentic version
  final bool hasAlternateHadithSahih;

  /// Whether this hadith has usul (original sources)
  final bool hasUsulHadith;

  /// URL to similar hadiths on Dorar.net
  final String? similarHadithDorar;

  /// URL to alternate authentic hadith on Dorar.net
  final String? alternateHadithSahihDorar;

  /// URL to usul hadith on Dorar.net
  final String? usulHadithDorar;

  /// Whether this hadith has sharh (explanation) metadata
  final bool hasSharhMetadata;

  /// Sharh metadata (if available)
  final SharhMetadata? sharhMetadata;

  const Hadith({
    required this.hadith,
    required this.rawi,
    required this.mohdith,
    this.mohdithId,
    required this.book,
    this.bookId,
    required this.numberOrPage,
    required this.grade,
    this.explainGrade,
    this.takhrij,
    this.hadithId,
    this.hasSimilarHadith = false,
    this.hasAlternateHadithSahih = false,
    this.hasUsulHadith = false,
    this.similarHadithDorar,
    this.alternateHadithSahihDorar,
    this.usulHadithDorar,
    this.hasSharhMetadata = false,
    this.sharhMetadata,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      hadith: json['hadith'] as String,
      rawi: json['rawi'] as String,
      mohdith: json['mohdith'] as String,
      mohdithId: json['mohdithId'] as String?,
      book: json['book'] as String,
      bookId: json['bookId'] as String?,
      numberOrPage: json['numberOrPage'] as String,
      grade: json['grade'] as String,
      explainGrade: json['explainGrade'] as String?,
      takhrij: json['takhrij'] as String?,
      hadithId: json['hadithId'] as String?,
      hasSimilarHadith: json['hasSimilarHadith'] as bool? ?? false,
      hasAlternateHadithSahih:
          json['hasAlternateHadithSahih'] as bool? ?? false,
      hasUsulHadith: json['hasUsulHadith'] as bool? ?? false,
      similarHadithDorar: json['similarHadithDorar'] as String?,
      alternateHadithSahihDorar: json['alternateHadithSahihDorar'] as String?,
      usulHadithDorar: json['usulHadithDorar'] as String?,
      hasSharhMetadata: json['hasSharhMetadata'] as bool? ?? false,
      sharhMetadata: json['sharhMetadata'] != null
          ? SharhMetadata.fromJson(
              json['sharhMetadata'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hadith': hadith,
      'rawi': rawi,
      'mohdith': mohdith,
      if (mohdithId != null) 'mohdithId': mohdithId,
      'book': book,
      if (bookId != null) 'bookId': bookId,
      'numberOrPage': numberOrPage,
      'grade': grade,
      if (explainGrade != null) 'explainGrade': explainGrade,
      if (takhrij != null) 'takhrij': takhrij,
      if (hadithId != null) 'hadithId': hadithId,
      'hasSimilarHadith': hasSimilarHadith,
      'hasAlternateHadithSahih': hasAlternateHadithSahih,
      'hasUsulHadith': hasUsulHadith,
      if (similarHadithDorar != null) 'similarHadithDorar': similarHadithDorar,
      if (alternateHadithSahihDorar != null)
        'alternateHadithSahihDorar': alternateHadithSahihDorar,
      if (usulHadithDorar != null) 'usulHadithDorar': usulHadithDorar,
      'hasSharhMetadata': hasSharhMetadata,
      if (sharhMetadata != null) 'sharhMetadata': sharhMetadata!.toJson(),
    };
  }

  @override
  String toString() {
    return 'Hadith(hadithId: $hadithId, hadith: ${hadith.length > 50 ? '${hadith.substring(0, 50)}...' : hadith}, '
        'rawi: $rawi, mohdith: $mohdith, mohdithId: $mohdithId, book: $book, bookId: $bookId, '
        'numberOrPage: $numberOrPage, grade: $grade, hasSimilarHadith: $hasSimilarHadith, '
        'hasAlternateHadithSahih: $hasAlternateHadithSahih, hasUsulHadith: $hasUsulHadith, '
        'hasSharhMetadata: $hasSharhMetadata)';
  }
}
