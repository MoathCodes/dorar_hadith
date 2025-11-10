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
  final String id;

  /// Arabic name (no separate nameAr - already in Arabic)
  final String name;

  const ReferenceItem({required this.id, required this.name});

  /// Creates a ReferenceItem from JSON.
  /// Expected format: {'key': '123', 'value': 'Name'}
  factory ReferenceItem.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Subclasses must implement fromJson');
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReferenceItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  /// Converts this ReferenceItem to JSON.
  /// Returns: {'key': id, 'value': name}
  Map<String, dynamic> toJson() {
    return {'key': id, 'value': name};
  }

  @override
  String toString() => '$runtimeType(id: $id, name: $name)';
}
