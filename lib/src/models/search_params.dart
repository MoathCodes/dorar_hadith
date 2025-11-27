import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/book_reference.dart';
import '../constants/hadith_degree.dart';
import '../constants/mohdith_reference.dart';
import '../constants/rawi_reference.dart';
import '../constants/search_method.dart';
import '../constants/search_zone.dart';

part 'search_params.freezed.dart';

/// Parameters for searching hadiths.
/// Provides a type-safe way to construct search queries.
@freezed
abstract class HadithSearchParams with _$HadithSearchParams {
  const factory HadithSearchParams({
    /// The search query text
    required String value,

    /// Page number for pagination (default: 1)
    @Default(1) int page,

    /// Whether to remove HTML tags from results (default: true)
    @Default(true) bool removeHtml,

    /// Include specialist/advanced hadiths (default: false)
    @Default(false) bool specialist,

    /// Words or phrases to exclude from search
    String? exclude,

    /// Search method (all words, any word, exact match)
    SearchMethod? searchMethod,

    /// Hadith type classification (all, marfoo, qudsi, athar, sharh)
    SearchZone? zone,

    /// Filter by hadith degrees (sahih, daif, etc.)
    List<HadithDegree>? degrees,

    /// Filter by specific scholars (mohdith)
    List<MohdithReference>? mohdith,

    /// Filter by specific books
    List<BookReference>? books,

    /// Filter by specific narrators (rawi)
    List<RawiReference>? rawi,
  }) = _HadithSearchParams;
}
