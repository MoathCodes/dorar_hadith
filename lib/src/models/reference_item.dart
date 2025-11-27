/// Base class for all reference data (books, scholars, narrators).
///
/// This is a lightweight model for browsing and filtering reference data
/// bundled as assets. It follows the pattern of existing constants
/// (RawiReference, BookReference, MohdithReference).
///
/// For detailed information, use the corresponding API models:
/// - MohdithItem → MohdithInfo (via MohdithService.getById)
/// - BookItem → BookInfo (via BookService.getById)
abstract class ReferenceItem {
  /// Unique identifier (String for API consistency)
  String get id;

  /// Arabic name (no separate nameAr - already in Arabic)
  String get name;

  /// Converts this ReferenceItem to JSON.
  Map<String, dynamic> toJson();
}
