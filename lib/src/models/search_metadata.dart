/// Metadata about search results from the API.
class SearchMetadata {
  /// Number of results returned
  final int length;

  /// Current page number
  final int? page;

  /// Whether HTML tags were removed from results
  final bool? removeHtml;

  /// Whether specialist/advanced hadiths are included
  final bool? specialist;

  /// Number of non-specialist hadiths
  final int? numberOfNonSpecialist;

  /// Number of specialist hadiths
  final int? numberOfSpecialist;

  /// Whether this result came from cache
  final bool isCached;

  /// Number of usul (sources) for usul hadith requests
  final int? usulSourcesCount;

  const SearchMetadata({
    required this.length,
    this.page,
    this.removeHtml,
    this.specialist,
    this.numberOfNonSpecialist,
    this.numberOfSpecialist,
    this.isCached = false,
    this.usulSourcesCount,
  });

  /// Create a modified copy of this metadata.
  ///
  /// All parameters are optional; if omitted the original value is kept.
  SearchMetadata copyWith({
    int? length,
    int? page,
    bool? removeHtml,
    bool? specialist,
    int? numberOfNonSpecialist,
    int? numberOfSpecialist,
    bool? isCached,
    int? usulSourcesCount,
  }) {
    return SearchMetadata(
      length: length ?? this.length,
      page: page ?? this.page,
      removeHtml: removeHtml ?? this.removeHtml,
      specialist: specialist ?? this.specialist,
      numberOfNonSpecialist:
          numberOfNonSpecialist ?? this.numberOfNonSpecialist,
      numberOfSpecialist: numberOfSpecialist ?? this.numberOfSpecialist,
      isCached: isCached ?? this.isCached,
      usulSourcesCount: usulSourcesCount ?? this.usulSourcesCount,
    );
  }

  factory SearchMetadata.fromJson(Map<String, dynamic> json) {
    return SearchMetadata(
      length: json['length'] as int? ?? 0,
      page: json['page'] as int?,
      removeHtml: json['removeHTML'] as bool?,
      specialist: json['specialist'] as bool?,
      numberOfNonSpecialist: json['numberOfNonSpecialist'] as int?,
      numberOfSpecialist: json['numberOfSpecialist'] as int?,
      isCached: json['isCached'] as bool? ?? false,
      usulSourcesCount: json['usulSourcesCount'] as int?,
    );
  }

  // duplicate copyWith removed

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      if (page != null) 'page': page,
      if (removeHtml != null) 'removeHTML': removeHtml,
      if (specialist != null) 'specialist': specialist,
      if (numberOfNonSpecialist != null)
        'numberOfNonSpecialist': numberOfNonSpecialist,
      if (numberOfSpecialist != null) 'numberOfSpecialist': numberOfSpecialist,
      'isCached': isCached,
      if (usulSourcesCount != null) 'usulSourcesCount': usulSourcesCount,
    };
  }

  @override
  String toString() {
    return 'SearchMetadata(length: $length, page: $page, removeHtml: $removeHtml, '
        'specialist: $specialist, numberOfNonSpecialist: $numberOfNonSpecialist, '
        'numberOfSpecialist: $numberOfSpecialist, isCached: $isCached, usulSourcesCount: $usulSourcesCount)';
  }
}
