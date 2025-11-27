import 'package:freezed_annotation/freezed_annotation.dart';

import 'reference_item.dart';

part 'book_item.freezed.dart';
part 'book_item.g.dart';

/// Lightweight model for book references.
///
/// For browsing/searching books from bundled assets.
/// For detailed book information, use [BookInfo] via [BookService.getById].
@freezed
abstract class BookItem with _$BookItem implements ReferenceItem {
  const factory BookItem({
    @JsonKey(name: 'key') required String id,
    @JsonKey(name: 'value') required String name,
    String? author,
    String? mohdithId,
    String? category,
  }) = _BookItem;

  factory BookItem.fromJson(Map<String, dynamic> json) =>
      _$BookItemFromJson(json);
}
