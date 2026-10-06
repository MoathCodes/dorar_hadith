import 'book_item.dart';
import 'mohdith_item.dart';
import 'rawi_item.dart';
import 'hadith.dart';

/// An opaque upstream identifier. Equality includes the identifier domain.
sealed class DorarId {
  const DorarId._(this.value);
  final String value;
  String toJson() => value;
  @override
  String toString() => value;
  @override
  bool operator ==(Object other) =>
      other is DorarId &&
      runtimeType == other.runtimeType &&
      value == other.value;
  @override
  int get hashCode => Object.hash(runtimeType, value);
}

String _validate(String value, RegExp pattern, String domain) {
  if (!pattern.hasMatch(value)) {
    throw ArgumentError.value(value, domain, 'Invalid identifier');
  }
  return value;
}

final class HadithRecordId extends DorarId {
  HadithRecordId(String value)
    : super._(_validate(value, RegExp(r'^[a-zA-Z0-9]+$'), 'hadithId'));
  factory HadithRecordId.fromJson(String value) => HadithRecordId(value);
}

final class SharhId extends DorarId {
  SharhId(String value)
    : super._(_validate(value, RegExp(r'^[1-9][0-9]*$'), 'sharhId'));
  factory SharhId.fromJson(String value) => SharhId(value);
}

final class BookId extends DorarId {
  BookId(String value)
    : super._(_validate(value, RegExp(r'^[0-9]+$'), 'bookId'));
  factory BookId.fromJson(String value) => BookId(value);
}

final class ScholarId extends DorarId {
  ScholarId(String value)
    : super._(_validate(value, RegExp(r'^[0-9]+$'), 'scholarId'));
  factory ScholarId.fromJson(String value) => ScholarId(value);
}

final class NarratorChoiceId extends DorarId {
  NarratorChoiceId(String value)
    : super._(_validate(value, RegExp(r'^[0-9]+$'), 'narratorChoiceId'));
  factory NarratorChoiceId.fromJson(String value) => NarratorChoiceId(value);
}

final class CategoryId extends DorarId {
  CategoryId(String value)
    : super._(_validate(value, RegExp(r'^[^\s/?#]+$'), 'categoryId'));
  factory CategoryId.fromJson(String value) => CategoryId(value);
}

/// The site's parent-category selector value, distinct from a leaf ID.
final class CategorySelector {
  CategorySelector(this.value) {
    if (value.trim().isEmpty) throw ArgumentError('Empty category selector');
  }
  final String value;
}

extension BookIdentifier on BookItem {
  BookId get typedId => BookId(id);
}

extension ScholarIdentifier on MohdithItem {
  ScholarId get typedId => ScholarId(id);
}

extension NarratorChoiceIdentifier on RawiItem {
  NarratorChoiceId get typedId => NarratorChoiceId(id);
}

extension RecordIdentifiers on DetailedHadith {
  HadithRecordId? get recordId =>
      hadithId == null ? null : HadithRecordId(hadithId!);
  BookId? get sourceId => bookId == null ? null : BookId(bookId!);
  ScholarId? get gradingScholarId =>
      mohdithId == null ? null : ScholarId(mohdithId!);
}
