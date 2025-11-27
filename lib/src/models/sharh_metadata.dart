import 'package:freezed_annotation/freezed_annotation.dart';

part 'sharh_metadata.freezed.dart';
part 'sharh_metadata.g.dart';

/// Metadata about sharh (explanation/commentary) for a hadith.
@freezed
abstract class SharhMetadata with _$SharhMetadata {
  const factory SharhMetadata({
    /// Unique identifier for the sharh
    required String id,

    /// Whether this response contains the actual sharh text
    @Default(false) bool isContainSharh,

    /// The actual sharh text (if available)
    String? sharh,
  }) = _SharhMetadata;

  factory SharhMetadata.fromJson(Map<String, dynamic> json) =>
      _$SharhMetadataFromJson(json);
}
