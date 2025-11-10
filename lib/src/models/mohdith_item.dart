import 'reference_item.dart';

/// Lightweight model for scholar (mohdith) references.
///
/// For browsing/searching scholars from bundled assets.
/// For detailed scholar information, use [MohdithInfo] via [MohdithService.getById].
class MohdithItem extends ReferenceItem {
  /// Hijri year of death (if available in source data)
  final int? deathYear;

  /// Era classification (e.g., 'Classical', 'Modern') if available
  final String? era;

  const MohdithItem({
    required super.id,
    required super.name,
    this.deathYear,
    this.era,
  });

  /// Creates a MohdithItem from JSON.
  ///
  /// Expected format:
  /// ```json
  /// {
  ///   "key": "256",
  ///   "value": "البخاري",
  ///   "deathYear": 256,  // optional
  ///   "era": "Classical" // optional
  /// }
  /// ```
  factory MohdithItem.fromJson(Map<String, dynamic> json) {
    return MohdithItem(
      id: json['key'] as String,
      name: json['value'] as String,
      deathYear: json['deathYear'] as int?,
      era: json['era'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (deathYear != null) json['deathYear'] = deathYear;
    if (era != null) json['era'] = era;
    return json;
  }

  @override
  String toString() =>
      'MohdithItem(id: $id, name: $name, deathYear: $deathYear, era: $era)';
}
