import 'reference_item.dart';

/// Minimal model for narrator (rawi) references.
///
/// Serves dual purpose:
/// 1. Public API model for browsing/searching narrators
/// 2. Custom row class for Drift database queries (via @UseRowClass)
class RawiItem extends ReferenceItem {
  const RawiItem({required super.id, required super.name});

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

  /// Creates a RawiItem from JSON (for constants/API compatibility).
  ///
  /// Expected format:
  /// ```json
  /// {
  ///   "key": "1416",
  ///   "value": "أبو هريرة"
  /// }
  /// ```
  factory RawiItem.fromJson(Map<String, dynamic> json) {
    return RawiItem(id: json['key'] as String, name: json['value'] as String);
  }

  @override
  String toString() => 'RawiItem(id: $id, name: $name)';
}
