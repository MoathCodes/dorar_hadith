import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadith_category.freezed.dart';
part 'hadith_category.g.dart';

/// Represents a thematic category (التصنيف الموضوعي) of a hadith.
///
/// Categories are extracted from category badge links on Dorar.net search results.
/// Each hadith may belong to zero or more thematic categories.
@freezed
abstract class HadithCategory with _$HadithCategory {
  const factory HadithCategory({
    /// The category ID (from the URL path)
    required String id,

    /// The Arabic category name
    required String name,
  }) = _HadithCategory;

  factory HadithCategory.fromJson(Map<String, dynamic> json) =>
      _$HadithCategoryFromJson(json);
}
