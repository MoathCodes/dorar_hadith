import 'package:freezed_annotation/freezed_annotation.dart';

import 'hadith.dart';
import 'sharh_metadata.dart';

part 'sharh.freezed.dart';
part 'sharh.g.dart';

/// Represents a hadith with its sharh (explanation/commentary).
@freezed
abstract class Sharh with _$Sharh {
  const Sharh._();
  const factory Sharh({
    required ExplainedHadith hadith,

    /// The sharh metadata (including the explanation text)
    SharhMetadata? sharhMetadata,
  }) = _Sharh;

  factory Sharh.fromJson(Map<String, dynamic> json) => _$SharhFromJson(json);

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
}
