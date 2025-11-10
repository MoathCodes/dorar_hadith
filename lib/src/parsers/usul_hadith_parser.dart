import 'package:html/dom.dart' as dom;

/// Data class holding parsed usul source information.
class ParsedUsulSource {
  /// The source book and page reference.
  final String source;

  /// The chain of narration (isnad).
  final String chain;

  /// The text of the hadith in this source.
  final String hadithText;

  const ParsedUsulSource({
    required this.source,
    required this.chain,
    required this.hadithText,
  });

  @override
  String toString() {
    return 'ParsedUsulSource(source: $source, '
        'chain: ${chain.substring(0, chain.length > 30 ? 30 : chain.length)}...)';
  }
}

/// Parser for extracting usul hadith sources from Dorar.net HTML.
class UsulHadithParser {
  UsulHadithParser._();

  /// Parse usul hadith sources from the document.
  ///
  /// Extracts source information from article elements, skipping the first one
  /// which contains the main hadith.
  static List<ParsedUsulSource> parseUsulSources(dom.Document doc) {
    final articles = doc.querySelectorAll('article');
    final sources = <ParsedUsulSource>[];

    // Skip the first article (main hadith) and process the rest
    for (var i = 1; i < articles.length; i++) {
      final article = articles[i];
      final sourceInfo = article.querySelector('h5');

      if (sourceInfo != null) {
        final parsed = _parseSourceInfo(sourceInfo);
        if (parsed != null) {
          sources.add(parsed);
        }
      }
    }

    return sources;
  }

  /// Parse a single source info element.
  static ParsedUsulSource? _parseSourceInfo(dom.Element sourceInfo) {
    // Extract source name from the span with maroon color
    final sourceSpan = sourceInfo.querySelector('span[style*="color:maroon"]');
    final sourceName = sourceSpan?.text.trim() ?? '';

    // Extract the chain of narration from the span with blue color
    final chainSpan = sourceInfo.querySelector('span[style*="color:blue"]');
    final chain = chainSpan?.text.trim() ?? '';

    // Get the full text
    var fullText = sourceInfo.text.trim();

    // Remove the source name and chain to get the actual hadith text
    if (sourceName.isNotEmpty) {
      fullText = fullText.replaceFirst(sourceName, '').trim();
    }
    if (chain.isNotEmpty) {
      fullText = fullText.replaceFirst(chain, '').trim();
    }

    // Clean up the hadith text (remove leading commas, periods, etc.)
    final hadithText = fullText.replaceFirst(RegExp(r'^[،,.\s]+'), '').trim();

    if (sourceName.isEmpty && chain.isEmpty && hadithText.isEmpty) {
      return null;
    }

    return ParsedUsulSource(
      source: sourceName,
      chain: chain,
      hadithText: hadithText,
    );
  }
}
