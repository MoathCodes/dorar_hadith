import 'package:freezed_annotation/freezed_annotation.dart';

import 'sharh_metadata.dart';

part 'hadith.freezed.dart';
part 'hadith.g.dart';

/// Represents a hadith with all Dorar-specific metadata.
@freezed
abstract class DetailedHadith with _$DetailedHadith, HadithBase {
  const factory DetailedHadith({
    required String hadith,
    required String rawi,
    required String mohdith,
    required String book,
    required String numberOrPage,
    required String grade,
    String? mohdithId,
    String? bookId,
    String? explainGrade,
    String? takhrij,
    String? hadithId,
    @Default(false) bool hasSimilarHadith,
    @Default(false) bool hasAlternateHadithSahih,
    @Default(false) bool hasUsulHadith,
    String? similarHadithDorar,
    String? alternateHadithSahihDorar,
    String? usulHadithDorar,
    @Default(false) bool hasSharhMetadata,
    SharhMetadata? sharhMetadata,
  }) = _DetailedHadith;
  factory DetailedHadith.fromJson(Map<String, dynamic> json) =>
      _$DetailedHadithFromJson(json);

  const DetailedHadith._();

  @override
  String get hukm => (explainGrade != null && explainGrade!.trim().isNotEmpty)
      ? explainGrade!
      : grade;
}

/// Lightweight hadith variant that carries takhrij and sharh availability.
@freezed
abstract class ExplainedHadith with _$ExplainedHadith, HadithBase {
  const factory ExplainedHadith({
    required String hadith,
    required String rawi,
    required String mohdith,
    required String book,
    required String numberOrPage,
    required String grade,
    String? takhrij,
    @Default(false) bool hasSharhMetadata,
  }) = _ExplainedHadith;
  factory ExplainedHadith.fromJson(Map<String, dynamic> json) =>
      _$ExplainedHadithFromJson(json);

  const ExplainedHadith._();
}

/// Lightweight hadith record returned by the public Dorar API.
@freezed
abstract class Hadith with _$Hadith, HadithBase {
  const factory Hadith({
    required String hadith,
    required String rawi,
    required String mohdith,
    required String book,
    required String numberOrPage,
    required String grade,
  }) = _Hadith;
  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);

  const Hadith._();
}

mixin HadithBase {
  String get book;
  String get grade;
  String get hadith;

  /// Unified verdict accessor.
  String get hukm => grade;
  String get mohdith;
  String get numberOrPage;

  String get rawi;
}
