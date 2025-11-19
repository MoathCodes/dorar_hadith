import 'package:equatable/equatable.dart';

import 'sharh_metadata.dart';

/// Represents a hadith with all Dorar-specific metadata.
///
/// Extends the lightweight [Hadith] class by adding identifiers, sharh
/// metadata, and links that are only available when scraping the site or
/// fetching detailed endpoints.
class DetailedHadith extends Hadith {
  /// ID of the mohdith
  final String? mohdithId;

  /// ID of the book
  final String? bookId;

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

  const DetailedHadith({
    required super.hadith,
    required super.rawi,
    required super.mohdith,
    this.mohdithId,
    required super.book,
    this.bookId,
    required super.numberOrPage,
    required super.grade,
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
  factory DetailedHadith.fromJson(Map<String, dynamic> json) {
    final base = Hadith.fromJson(json);

    return DetailedHadith(
      hadith: base.hadith,
      rawi: base.rawi,
      mohdith: base.mohdith,
      mohdithId: json['mohdithId'] as String?,
      book: base.book,
      bookId: json['bookId'] as String?,
      numberOrPage: base.numberOrPage,
      grade: base.grade,
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

  /// Unified verdict accessor.
  ///
  /// Returns [explainGrade] when it is non-empty, otherwise falls back to
  /// the base [grade]. This avoids branching in consumers that just want to
  /// print the ruling/verdict.
  @override
  String get hukm => (explainGrade != null && explainGrade!.trim().isNotEmpty)
      ? explainGrade!
      : grade;

  @override
  List<Object?> get props => [
    ...super.props,
    mohdithId,
    bookId,
    explainGrade,
    takhrij,
    hadithId,
    hasSimilarHadith,
    hasAlternateHadithSahih,
    hasUsulHadith,
    similarHadithDorar,
    alternateHadithSahihDorar,
    usulHadithDorar,
    hasSharhMetadata,
    sharhMetadata,
  ];

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (mohdithId != null) 'mohdithId': mohdithId,
      if (bookId != null) 'bookId': bookId,
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

/// Lightweight hadith variant that carries takhrij and sharh availability
/// without promoting to the full [DetailedHadith] payload.
class ExplainedHadith extends Hadith {
  /// Optional takhrij information for the hadith.
  final String? takhrij;

  /// Whether the hadith has associated sharh metadata.
  final bool hasSharhMetadata;

  const ExplainedHadith({
    required super.hadith,
    required super.rawi,
    required super.mohdith,
    required super.book,
    required super.numberOrPage,
    required super.grade,
    this.takhrij,
    this.hasSharhMetadata = false,
  });

  factory ExplainedHadith.fromJson(Map<String, dynamic> json) {
    final base = Hadith.fromJson(json);
    return ExplainedHadith(
      hadith: base.hadith,
      rawi: base.rawi,
      mohdith: base.mohdith,
      book: base.book,
      numberOrPage: base.numberOrPage,
      grade: base.grade,
      takhrij: json['takhrij'] as String?,
      hasSharhMetadata: json['hasSharhMetadata'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [...super.props, takhrij, hasSharhMetadata];

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (takhrij != null) 'takhrij': takhrij,
      'hasSharhMetadata': hasSharhMetadata,
    };
  }

  @override
  String toString() {
    return 'ExplainedHadith(hadith: ${hadith.length > 50 ? '${hadith.substring(0, 50)}...' : hadith}, '
        'rawi: $rawi, mohdith: $mohdith, book: $book, numberOrPage: $numberOrPage, '
        'grade: $grade, takhrij: ${takhrij ?? 'null'}, hasSharhMetadata: $hasSharhMetadata)';
  }
}

/// Lightweight hadith record returned by the public Dorar API.
///
/// This type captures the core textual information (matn, rawi, book, grade)
/// and is extended by [DetailedHadith] when richer metadata is available.
class Hadith extends Equatable {
  /// The text of the hadith
  final String hadith;

  /// The narrator/transmitter (rawi)
  final String rawi;

  /// The scholar who authenticated it (mohdith)
  final String mohdith;

  /// The book/source this hadith is from
  final String book;

  /// Page number or hadith number in the source
  final String numberOrPage;

  /// Grade/ruling of the hadith (sahih, daif, etc.)
  final String grade;

  const Hadith({
    required this.hadith,
    required this.rawi,
    required this.mohdith,
    required this.book,
    required this.numberOrPage,
    required this.grade,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      hadith: json['hadith'] as String,
      rawi: json['rawi'] as String,
      mohdith: json['mohdith'] as String,
      book: json['book'] as String,
      numberOrPage: json['numberOrPage'] as String,
      grade: json['grade'] as String,
    );
  }

  /// Unified verdict accessor (for lightweight hadith this is just [grade]).
  String get hukm => grade;

  @override
  List<Object?> get props => [hadith, rawi, mohdith, book, numberOrPage, grade];

  Map<String, dynamic> toJson() {
    return {
      'hadith': hadith,
      'rawi': rawi,
      'mohdith': mohdith,
      'book': book,
      'numberOrPage': numberOrPage,
      'grade': grade,
    };
  }

  @override
  String toString() {
    return 'BaseHadith(hadith: ${hadith.length > 50 ? '${hadith.substring(0, 50)}...' : hadith}, '
        'rawi: $rawi, mohdith: $mohdith, book: $book, numberOrPage: $numberOrPage, grade: $grade)';
  }
}
