import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_metadata.freezed.dart';
part 'search_metadata.g.dart';

/// Metadata about search results from the API.
@freezed
abstract class SearchMetadata with _$SearchMetadata {
  const factory SearchMetadata({
    /// Number of results returned
    @Default(0) int length,

    /// Number of results on this page (same as length for consistency with Node.js API)
    int? currentPageCount,

    /// Total number of results across all pages (site endpoint only)
    int? total,

    /// Current page number
    int? page,

    /// Total number of pages (site endpoint only)
    int? totalPages,

    /// Whether there is a next page
    bool? hasNextPage,

    /// Whether there is a previous page
    bool? hasPrevPage,

    /// Whether HTML tags were removed from results
    @JsonKey(name: 'removeHTML') bool? removeHtml,

    /// Whether specialist/advanced hadiths are included
    bool? specialist,

    /// Number of non-specialist hadiths
    int? numberOfNonSpecialist,

    /// Number of specialist hadiths
    int? numberOfSpecialist,

    /// Whether this result came from cache
    @Default(false) bool isCached,

    /// Number of usul (sources) for usul hadith requests
    int? usulSourcesCount,
  }) = _SearchMetadata;

  factory SearchMetadata.fromJson(Map<String, dynamic> json) =>
      _$SearchMetadataFromJson(json);
}
