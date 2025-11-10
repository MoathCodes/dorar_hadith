/// Enum representing the different degrees/grades of hadith authenticity.
/// Based on the rulings of hadith scholars.
enum HadithDegree {
  /// All degrees - no filter
  all('0', 'جميع الدرجات'),

  /// Hadiths that scholars ruled as authentic (sahih)
  authenticHadith('1', 'أحاديث حكم المحدثون عليها بالصحة، ونحو ذلك'),

  /// Hadiths whose chains (isnad) scholars ruled as authentic
  authenticChain('2', 'أحاديث حكم المحدثون على أسانيدها بالصحة، ونحو ذلك'),

  /// Hadiths that scholars ruled as weak (daif)
  weakHadith('3', 'أحاديث حكم المحدثون عليها بالضعف، ونحو ذلك'),

  /// Hadiths whose chains (isnad) scholars ruled as weak
  weakChain('4', 'أحاديث حكم المحدثون على أسانيدها بالضعف، ونحو ذلك');

  /// The ID/key used in API calls
  final String id;

  /// The Arabic label describing this degree
  final String label;

  const HadithDegree(this.id, this.label);

  /// Convert to query parameter value
  String toQueryParam() => id;

  @override
  String toString() => label;

  /// Lookup a HadithDegree by its ID
  static HadithDegree? fromId(String id) {
    try {
      return HadithDegree.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
