import 'reference_item.dart';

/// Lightweight model for book references.
///
/// For browsing/searching books from bundled assets.
/// For detailed book information, use [BookInfo] via [BookService.getById].
class BookItem extends ReferenceItem {
  /// Author name (if available in source data)
  final String? author;

  /// ID of the scholar (mohdith) who authored this book
  final String? mohdithId;

  /// Category classification (if available)
  final String? category;

  const BookItem({
    required super.id,
    required super.name,
    this.author,
    this.mohdithId,
    this.category,
  });

  /// Creates a BookItem from JSON.
  ///
  /// Expected format:
  /// ```json
  /// {
  ///   "key": "6216",
  ///   "value": "صحيح البخاري",
  ///   "author": "البخاري",        // optional
  ///   "mohdithId": "256",         // optional
  ///   "category": "Sahih"         // optional
  /// }
  /// ```
  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['key'] as String,
      name: json['value'] as String,
      author: json['author'] as String?,
      mohdithId: json['mohdithId'] as String?,
      category: json['category'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (author != null) json['author'] = author;
    if (mohdithId != null) json['mohdithId'] = mohdithId;
    if (category != null) json['category'] = category;
    return json;
  }

  @override
  String toString() =>
      'BookItem(id: $id, name: $name, author: $author, category: $category)';
}
