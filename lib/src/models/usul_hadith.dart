import 'hadith.dart';

/// Represents the complete Usul Hadith response with the main hadith
/// and all its sources/chains.
class UsulHadith {
  /// The main hadith
  final DetailedHadith hadith;

  /// List of all sources for this hadith
  final List<UsulSource> sources;

  /// Total count of sources
  final int count;

  const UsulHadith({
    required this.hadith,
    required this.sources,
    required this.count,
  });

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

  Map<String, dynamic> toJson() {
    final json = hadith.toJson();
    json['usulHadith'] = {
      'sources': sources.map((s) => s.toJson()).toList(),
      'count': count,
    };
    return json;
  }

  @override
  String toString() {
    return 'UsulHadith(count: $count, hadith: $hadith, sources: ${sources.length} sources)';
  }
}

/// Represents a source/chain for a hadith in Usul Hadith.
class UsulSource {
  /// The source book and page reference
  final String source;

  /// The chain of narration (isnad)
  final String chain;

  /// The text of the hadith in this source
  final String hadithText;

  const UsulSource({
    required this.source,
    required this.chain,
    required this.hadithText,
  });

  factory UsulSource.fromJson(Map<String, dynamic> json) {
    return UsulSource(
      source: json['source'] as String,
      chain: json['chain'] as String,
      hadithText: json['hadithText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'source': source, 'chain': chain, 'hadithText': hadithText};
  }

  @override
  String toString() {
    return 'UsulSource(source: $source, chain: ${chain.length > 50 ? '${chain.substring(0, 50)}...' : chain}, '
        'hadithText: ${hadithText.length > 50 ? '${hadithText.substring(0, 50)}...' : hadithText})';
  }
}
