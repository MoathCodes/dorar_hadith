/// Enum representing different search methods for hadith queries.
enum SearchMethod {
  /// Search for all words in the query (AND operation)
  allWords('w', 'جميع الكلمات'),

  /// Search for any word in the query (OR operation)
  anyWord('a', 'أي كلمة'),

  /// Search for exact phrase match
  exactMatch('p', 'بحث مطابق');

  /// The ID/key used in API calls
  final String id;

  /// The Arabic label describing this method
  final String label;

  const SearchMethod(this.id, this.label);

  /// Convert to query parameter value
  String toQueryParam() => id;

  @override
  String toString() => label;

  /// Lookup a SearchMethod by its ID
  static SearchMethod? fromId(String id) {
    try {
      return SearchMethod.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
