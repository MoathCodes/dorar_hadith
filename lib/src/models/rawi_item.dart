import 'package:freezed_annotation/freezed_annotation.dart';
import 'reference_item.dart';

part 'rawi_item.freezed.dart';
part 'rawi_item.g.dart';

/// Minimal model for narrator (rawi) references.
///
/// Serves dual purpose:
/// 1. Public API model for browsing/searching narrators
/// 2. Custom row class for Drift database queries (via @UseRowClass)
@freezed
abstract class RawiItem with _$RawiItem implements ReferenceItem {
  const factory RawiItem({
    @JsonKey(name: 'key') required String id,
    @JsonKey(name: 'value') required String name,
  }) = _RawiItem;

  factory RawiItem.fromJson(Map<String, dynamic> json) =>
      _$RawiItemFromJson(json);

  /// Constructor for Drift to use when mapping database rows.
  ///
  /// Drift will call: `RawiItem.fromDatabase(key: row['key'], value: row['value'])`
  ///
  /// Parameters:
  /// - [key]: Database column 'key' (int) - unique narrator ID
  /// - [value]: Database column 'value' (text) - Arabic name (already normalized)
  factory RawiItem.fromDatabase({required int key, required String value}) {
    return RawiItem(
      id: key.toString(), // Convert int → String for API consistency
      name: value, // Already normalized Arabic (no diacritics)
    );
  }
}
