/// Utilities for searching and matching Arabic text.
///
/// Provides normalization functions that:
/// - Remove diacritics (تشكيل)
/// - Normalize different forms of the same letter
/// - Enable fuzzy matching for user queries
library;

/// Check if a text contains a query using fuzzy Arabic matching.
///
/// Both [text] and [query] are normalized before comparison,
/// making the search diacritic-insensitive and more forgiving.
///
/// Example:
/// ```dart
/// fuzzyMatch('أبو هُرَيْرَة', 'ابو هريره'); // Returns: true
/// fuzzyMatch('محمد بن عبدالله', 'محمد'); // Returns: true
/// fuzzyMatch('علي بن أبي طالب', 'عثمان'); // Returns: false
/// ```
bool fuzzyMatch(String text, String query) {
  final normalizedText = normalizeArabicSearch(text.toLowerCase());
  final normalizedQuery = normalizeArabicSearch(query.toLowerCase());
  return normalizedText.contains(normalizedQuery);
}

/// Normalize Arabic text for searching by removing diacritics and
/// normalizing letter variations.
///
/// This function:
/// - Removes harakat (تشكيل): َ ُ ِ ّ ً ٌ ٍ ْ
/// - Normalizes Alef variations: أ إ آ → ا
/// - Normalizes Ya variations: ى → ي
/// - Normalizes Ta Marbuta: ة → ه
///
/// Example:
/// ```dart
/// normalizeArabicSearch('مُحَمَّد'); // Returns: 'محمد'
/// normalizeArabicSearch('إبراهيم'); // Returns: 'ابراهيم'
/// ```
String normalizeArabicSearch(String text) {
  String normalized = text;

  // Remove common Arabic diacritics (harakat)
  const diacritics = [
    '\u064B', // Fathatan (ً)
    '\u064C', // Dammatan (ٌ)
    '\u064D', // Kasratan (ٍ)
    '\u064E', // Fatha (َ)
    '\u064F', // Damma (ُ)
    '\u0650', // Kasra (ِ)
    '\u0651', // Shadda (ّ)
    '\u0652', // Sukun (ْ)
    '\u0653', // Maddah (ٓ)
    '\u0654', // Hamza above (ٔ)
    '\u0655', // Hamza below (ٕ)
    '\u0656', // Subscript Alef (ٖ)
    '\u0670', // Superscript Alef (ٰ)
  ];

  for (final diacritic in diacritics) {
    normalized = normalized.replaceAll(diacritic, '');
  }

  // Normalize Alef variations
  normalized = normalized
      .replaceAll('أ', 'ا') // Alef with Hamza above
      .replaceAll('إ', 'ا') // Alef with Hamza below
      .replaceAll('آ', 'ا') // Alef with Madda
      .replaceAll('ٱ', 'ا'); // Alef Wasla

  // Normalize Ya
  normalized = normalized.replaceAll('ى', 'ي'); // Alef Maksura → Ya

  // Normalize Ta Marbuta
  normalized = normalized.replaceAll('ة', 'ه'); // Ta Marbuta → Ha

  return normalized;
}

/// Calculate a simple similarity score between two Arabic strings.
///
/// Returns a value between 0.0 (completely different) and 1.0 (identical).
/// Uses normalized text for comparison.
///
/// This is a basic implementation based on substring matching.
/// More sophisticated algorithms (like Levenshtein distance) can be added later.
///
/// Example:
/// ```dart
/// similarityScore('محمد', 'محمد'); // Returns: 1.0
/// similarityScore('أبو بكر', 'ابو بكر'); // Returns: 1.0 (normalized match)
/// similarityScore('علي', 'عمر'); // Returns: 0.0
/// ```
double similarityScore(String text1, String text2) {
  final normalized1 = normalizeArabicSearch(text1.toLowerCase());
  final normalized2 = normalizeArabicSearch(text2.toLowerCase());

  if (normalized1 == normalized2) {
    return 1.0;
  }

  if (normalized1.isEmpty || normalized2.isEmpty) {
    return 0.0;
  }

  // Simple substring-based similarity
  if (normalized1.contains(normalized2) || normalized2.contains(normalized1)) {
    final shorter = normalized1.length < normalized2.length
        ? normalized1.length
        : normalized2.length;
    final longer = normalized1.length > normalized2.length
        ? normalized1.length
        : normalized2.length;
    return shorter / longer;
  }

  return 0.0;
}
