import 'sharh_metadata.dart';

/// Represents a hadith with its sharh (explanation/commentary).
class Sharh {
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

  /// Grade/ruling of the hadith
  final String grade;

  /// Takhrij (other sources this hadith appears in)
  final String? takhrij;

  /// Whether this has sharh metadata
  final bool hasSharhMetadata;

  /// The sharh metadata (including the explanation text)
  final SharhMetadata? sharhMetadata;

  const Sharh({
    required this.hadith,
    required this.rawi,
    required this.mohdith,
    required this.book,
    required this.numberOrPage,
    required this.grade,
    this.takhrij,
    this.hasSharhMetadata = false,
    this.sharhMetadata,
  });

  factory Sharh.fromJson(Map<String, dynamic> json) {
    return Sharh(
      hadith: json['hadith'] as String,
      rawi: json['rawi'] as String,
      mohdith: json['mohdith'] as String,
      book: json['book'] as String,
      numberOrPage: json['numberOrPage'] as String,
      grade: json['grade'] as String,
      takhrij: json['takhrij'] as String?,
      hasSharhMetadata: json['hasSharhMetadata'] as bool? ?? false,
      sharhMetadata: json['sharhMetadata'] != null
          ? SharhMetadata.fromJson(
              json['sharhMetadata'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Get the sharh text if available
  String? get sharhText => sharhMetadata?.sharh;

  Map<String, dynamic> toJson() {
    return {
      'hadith': hadith,
      'rawi': rawi,
      'mohdith': mohdith,
      'book': book,
      'numberOrPage': numberOrPage,
      'grade': grade,
      if (takhrij != null) 'takhrij': takhrij,
      'hasSharhMetadata': hasSharhMetadata,
      if (sharhMetadata != null) 'sharhMetadata': sharhMetadata!.toJson(),
    };
  }

  @override
  String toString() {
    return 'Sharh(hadith: ${hadith.length > 50 ? '${hadith.substring(0, 50)}...' : hadith}, '
        'rawi: $rawi, mohdith: $mohdith, book: $book, numberOrPage: $numberOrPage, '
        'grade: $grade, hasSharhMetadata: $hasSharhMetadata)';
  }
}
