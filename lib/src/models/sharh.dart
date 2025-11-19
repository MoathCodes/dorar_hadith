import 'package:dorar_hadith/dorar_hadith.dart';

/// Represents a hadith with its sharh (explanation/commentary).
class Sharh {
  final ExplainedHadith hadith;

  /// The sharh metadata (including the explanation text)
  final SharhMetadata? sharhMetadata;

  const Sharh({required this.hadith, this.sharhMetadata});

  factory Sharh.fromJson(Map<String, dynamic> json) {
    return Sharh(
      hadith: ExplainedHadith.fromJson(json),
      sharhMetadata: json['sharhMetadata'] != null
          ? SharhMetadata.fromJson(
              json['sharhMetadata'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// The source book name.
  String get book => hadith.book;

  /// The hadith grade.
  String get grade => hadith.grade;

  // === Pass-through getters to the embedded hadith for convenience ===

  /// The hadith text (matn).
  String get hadithText => hadith.hadith;

  /// The scholar (mohdith).
  String get mohdith => hadith.mohdith;

  /// Page or number in the source.
  String get numberOrPage => hadith.numberOrPage;

  /// The narrator (rawi).
  String get rawi => hadith.rawi;

  /// Get the sharh text if available
  String? get sharhText => sharhMetadata?.sharh;

  /// Optional takhrij information.
  String? get takhrij => hadith.takhrij;

  /// Alias for [sharhText] to reduce friction in examples.
  String? get text => sharhText;

  /// Unified verdict accessor for Sharh (maps to hadith grade).
  String get verdict => hadith.grade;

  Map<String, dynamic> toJson() {
    return {
      ...hadith.toJson(),
      if (sharhMetadata != null) 'sharhMetadata': sharhMetadata!.toJson(),
    };
  }

  @override
  String toString() {
    return 'Sharh(${hadith.toString()}, sharhMetadata: ${sharhMetadata.toString()})';
  }
}
