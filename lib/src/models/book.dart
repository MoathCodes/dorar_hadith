/// Represents information about a book containing hadiths.
class BookInfo {
  /// Name of the book
  final String name;

  /// Unique identifier
  final String bookId;

  /// Author of the book
  final String author;

  /// Reviewer/editor of the book
  final String reviewer;

  /// Publisher
  final String publisher;

  /// Edition number
  final String edition;

  /// Year of the edition
  final String editionYear;

  const BookInfo({
    required this.name,
    required this.bookId,
    required this.author,
    required this.reviewer,
    required this.publisher,
    required this.edition,
    required this.editionYear,
  });

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    return BookInfo(
      name: json['name'] as String,
      bookId: json['bookId'] as String,
      author: json['author'] as String,
      reviewer: json['reviewer'] as String,
      publisher: json['publisher'] as String,
      edition: json['edition'] as String,
      editionYear: json['editionYear'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bookId': bookId,
      'author': author,
      'reviewer': reviewer,
      'publisher': publisher,
      'edition': edition,
      'editionYear': editionYear,
    };
  }

  @override
  String toString() {
    return 'BookInfo(bookId: $bookId, name: $name, author: $author, '
        'reviewer: $reviewer, publisher: $publisher, edition: $edition, editionYear: $editionYear)';
  }
}
