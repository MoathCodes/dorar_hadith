import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

/// Represents information about a book containing hadiths.
@freezed
abstract class BookInfo with _$BookInfo {
  const factory BookInfo({
    /// Name of the book
    required String name,

    /// Unique identifier
    required String bookId,

    /// Author of the book
    required String author,

    /// Reviewer/editor of the book
    required String reviewer,

    /// Publisher
    required String publisher,

    /// Edition number
    required String edition,

    /// Year of the edition
    required String editionYear,
  }) = _BookInfo;

  factory BookInfo.fromJson(Map<String, dynamic> json) =>
      _$BookInfoFromJson(json);
}
