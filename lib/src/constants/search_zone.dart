/// Enum representing different hadith type classifications.
/// Used to filter hadiths by their category/nature rather than where to search.
enum SearchZone {
  /// All hadiths (no filter)
  all('*', 'جميع الأحاديث'),

  /// Marfoo hadiths (attributed to the Prophet ﷺ)
  marfoo('0', 'الأحاديث المرفوعة'),

  /// Qudsi hadiths (sacred hadiths from Allah)
  qudsi('1', 'الأحاديث القدسية'),

  /// Athar (narrations from the Companions)
  sahabaAthar('2', 'آثار الصحابة'),

  /// Sharh (explanations/commentaries on hadiths)
  sharh('3', 'شروح الأحاديث');

  /// The ID/key used in API calls
  final String id;

  /// The Arabic label describing this hadith type
  final String label;

  const SearchZone(this.id, this.label);

  /// Convert to query parameter value
  String toQueryParam() => id;

  @override
  String toString() => label;

  /// Lookup a SearchZone by its ID
  static SearchZone? fromId(String id) {
    try {
      return SearchZone.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
