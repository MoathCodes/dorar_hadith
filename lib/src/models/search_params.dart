import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/book_reference.dart';
import '../constants/hadith_degree.dart';
import '../constants/mohdith_reference.dart';
import '../constants/rawi_reference.dart';
import '../constants/search_method.dart';
import '../constants/search_zone.dart';
import '../constants/hadith_type_filter.dart';
import 'result_details.dart';
import 'identifiers.dart';

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

    /// When `true`, use Dorar.net's `#specialist` tab (`&all` URL flag): results
    /// include takhrij metadata and only hadiths that have takhrij are returned.
    /// Dorar labels this tab "متخصص" in its UI; the parameter name is historical.
    @Default(false) bool specialist,

    /// Words or phrases to exclude from search
    String? exclude,

    /// Search method (all words, any word, exact match)
    SearchMethod? searchMethod,

    /// Hadith type classification (all, marfoo, qudsi, athar, sharh)
    SearchZone? zone,
    @Default(<HadithTypeFilter>{}) Set<HadithTypeFilter> types,
    HadithSort? sort,
    @Default(<String>[]) List<String> optionalPhrases,
    @Default(ParsePolicy.strict) ParsePolicy parsePolicy,

    /// Filter by hadith degrees (sahih, daif, etc.)
    List<HadithDegree>? degrees,

    /// Filter by specific scholars (mohdith)
    List<MohdithReference>? mohdith,

    /// Filter by specific books
    List<BookReference>? books,

    /// Filter by specific narrators (rawi)
    List<RawiReference>? rawi,
    @Default([]) List<ScholarId> scholarIds,
    @Default([]) List<BookId> bookIds,
    @Default([]) List<NarratorChoiceId> narratorChoiceIds,
  }) = _HadithSearchParams;
}

/// Search explanation prose. Its snippets are not complete hadith records.
class SharhTextSearchParams {
  const SharhTextSearchParams({
    required this.value,
    this.page = 1,
    this.parsePolicy = ParsePolicy.strict,
  });
  final String value;
  final int page;
  final ParsePolicy parsePolicy;
}
