import '../constants/book_reference.dart';
import '../constants/hadith_degree.dart';
import '../constants/mohdith_reference.dart';
import '../constants/rawi_reference.dart';
import '../constants/search_method.dart';
import '../constants/search_zone.dart';

/// Parameters for searching hadiths.
/// Provides a type-safe way to construct search queries.
class HadithSearchParams {
  /// The search query text
  final String value;

  /// Page number for pagination (default: 1)
  final int page;

  /// Whether to remove HTML tags from results (default: true)
  final bool removeHtml;

  /// Include specialist/advanced hadiths (default: false)
  final bool specialist;

  /// Words or phrases to exclude from search
  final String? exclude;

  /// Search method (all words, any word, exact match)
  final SearchMethod? searchMethod;

  /// Hadith type classification (all, marfoo, qudsi, athar, sharh)
  final SearchZone? zone;

  /// Filter by hadith degrees (sahih, daif, etc.)
  final List<HadithDegree>? degrees;

  /// Filter by specific scholars (mohdith)
  final List<MohdithReference>? mohdith;

  /// Filter by specific books
  final List<BookReference>? books;

  /// Filter by specific narrators (rawi)
  final List<RawiReference>? rawi;

  const HadithSearchParams({
    required this.value,
    this.page = 1,
    this.removeHtml = true,
    this.specialist = false,
    this.exclude,
    this.searchMethod,
    this.zone,
    this.degrees,
    this.mohdith,
    this.books,
    this.rawi,
  });

  /// Create a copy with modified parameters
  HadithSearchParams copyWith({
    String? value,
    int? page,
    bool? removeHtml,
    bool? specialist,
    String? exclude,
    SearchMethod? searchMethod,
    SearchZone? zone,
    List<HadithDegree>? degrees,
    List<MohdithReference>? mohdith,
    List<BookReference>? books,
    List<RawiReference>? rawi,
  }) {
    return HadithSearchParams(
      value: value ?? this.value,
      page: page ?? this.page,
      removeHtml: removeHtml ?? this.removeHtml,
      specialist: specialist ?? this.specialist,
      exclude: exclude ?? this.exclude,
      searchMethod: searchMethod ?? this.searchMethod,
      zone: zone ?? this.zone,
      degrees: degrees ?? this.degrees,
      mohdith: mohdith ?? this.mohdith,
      books: books ?? this.books,
      rawi: rawi ?? this.rawi,
    );
  }

  @override
  String toString() {
    return 'HadithSearchParams(value: $value, page: $page, removeHtml: $removeHtml, '
        'specialist: $specialist, exclude: $exclude, searchMethod: $searchMethod, '
        'zone: $zone, degrees: $degrees, mohdith: $mohdith, books: $books, rawi: $rawi)';
  }
}
