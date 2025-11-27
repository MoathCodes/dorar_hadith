import 'package:freezed_annotation/freezed_annotation.dart';

import 'hadith.dart';

part 'usul_hadith.freezed.dart';
part 'usul_hadith.g.dart';

/// Represents the complete Usul Hadith response with the main hadith
/// and all its sources/chains.
@freezed
abstract class UsulHadith with _$UsulHadith {
  const factory UsulHadith({
    /// The main hadith
    required DetailedHadith hadith,

    /// List of all sources for this hadith
    required List<UsulSource> sources,

    /// Total count of sources
    required int count,
  }) = _UsulHadith;
  factory UsulHadith.fromJson(Map<String, dynamic> json) {
    // The main hadith fields are at the root level
    final hadith = DetailedHadith.fromJson(json);

    // The usul hadith specific data
    final usulData = json['usulHadith'] as Map<String, dynamic>?;

    final sources = usulData != null && usulData['sources'] != null
        ? (usulData['sources'] as List)
              .map((s) => UsulSource.fromJson(s as Map<String, dynamic>))
              .toList()
        : <UsulSource>[];

    final count = usulData?['count'] as int? ?? sources.length;

    return UsulHadith(hadith: hadith, sources: sources, count: count);
  }

  const UsulHadith._();

  Map<String, dynamic> toJson() {
    final json = hadith.toJson();
    json['usulHadith'] = {
      'sources': sources.map((s) => s.toJson()).toList(),
      'count': count,
    };
    return json;
  }
}

/// Represents a source/chain for a hadith in Usul Hadith.
@freezed
abstract class UsulSource with _$UsulSource {
  const factory UsulSource({
    /// The source book and page reference
    required String source,

    /// The chain of narration (isnad)
    required String chain,

    /// The text of the hadith in this source
    required String hadithText,
  }) = _UsulSource;

  factory UsulSource.fromJson(Map<String, dynamic> json) =>
      _$UsulSourceFromJson(json);
}
