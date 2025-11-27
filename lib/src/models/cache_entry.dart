import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_entry.freezed.dart';
part 'cache_entry.g.dart';

@freezed
abstract class CacheEntry with _$CacheEntry {
  const factory CacheEntry({
    required String key,

    /// The cached data
    required String body,
    required String header,

    /// The timestamp when the data was cached
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _CacheEntry;

  factory CacheEntry.fromJson(Map<String, dynamic> json) =>
      _$CacheEntryFromJson(json);
}

extension CacheEntryX on CacheEntry {
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
