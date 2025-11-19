import 'package:equatable/equatable.dart';

/// Metadata about sharh (explanation/commentary) for a hadith.
class SharhMetadata extends Equatable {
  /// Unique identifier for the sharh
  final String id;

  /// Whether this response contains the actual sharh text
  final bool isContainSharh;

  /// The actual sharh text (if available)
  final String? sharh;

  const SharhMetadata({
    required this.id,
    required this.isContainSharh,
    this.sharh,
  });

  factory SharhMetadata.fromJson(Map<String, dynamic> json) {
    return SharhMetadata(
      id: json['id'] as String,
      isContainSharh: json['isContainSharh'] as bool? ?? false,
      sharh: json['sharh'] as String?,
    );
  }

  @override
  int get hashCode => id.hashCode ^ isContainSharh.hashCode ^ sharh.hashCode;

  @override
  List<Object?> get props => [id, isContainSharh, sharh];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharhMetadata &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isContainSharh == other.isContainSharh &&
          sharh == other.sharh;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isContainSharh': isContainSharh,
      if (sharh != null) 'sharh': sharh,
    };
  }

  @override
  String toString() {
    return 'SharhMetadata(id: $id, isContainSharh: $isContainSharh, '
        'sharh: ${sharh != null ? '${sharh!.length > 50 ? '${sharh!.substring(0, 50)}...' : sharh}' : 'null'})';
  }
}
