import 'package:html/dom.dart' as dom;

import '../models/hadith_category.dart';

/// Display prefix cleanup. Source text and HTML must remain untouched.
enum HadithTextCleanMode {
  /// Site/API search listings: strip leading `N -` numbering only.
  search,

  /// By-id / similar / alternate / usul: strip `-` / `- :` prefixes.
  detail,
}

/// Utilities for parsing hadith information from HTML DOM elements.
///
/// This replicates the parsing logic from the Node.js version's
/// `parseHadithInfo.js` and `parseHadithCategories.js` files.
class HadithParser {
  HadithParser._();

  /// Remove only a verified leading display prefix.
  ///
  /// - [HadithTextCleanMode.search]: leading result numbering.
  /// - [HadithTextCleanMode.detail]: leading dash/colon separator.
  static String cleanHadithText(String text, HadithTextCleanMode mode) {
    switch (mode) {
      case HadithTextCleanMode.search:
        return text.replaceAll(RegExp(r'^\s*\d+\s+-\s*'), '').trim();
      case HadithTextCleanMode.detail:
        return text.replaceAll(RegExp(r'^\s*-\s*:?\s*'), '').trim();
    }
  }

  /// Extract alternate hadith URL from DOM element.
  ///
  /// Looks for a link ending with `?alts=1` which indicates alternate sahih hadith.
  static String? getAlternateHadithUrl(dom.Element element) {
    final anchor = element.querySelector('a[href\$="?alts=1"]');
    return anchor?.attributes['href'];
  }

  /// Extract hadith ID from DOM element.
  ///
  /// Gets the hadith ID from the `tag` attribute of an anchor element.
  /// This is used to construct URLs for similar/alternate/usul hadiths.
  static String? getHadithId(dom.Element element) {
    final anchor = element.querySelector('a[tag]');
    return anchor?.attributes['tag'] ??
        element
            .querySelector('[data-name="hadith"][data-pk]')
            ?.attributes['data-pk'];
  }

  /// Extract similar hadith URL from DOM element.
  ///
  /// Looks for a link ending with `?sims=1` which indicates similar hadiths.
  static String? getSimilarHadithUrl(dom.Element element) {
    final anchor = element.querySelector('a[href\$="?sims=1"]');
    return anchor?.attributes['href'];
  }

  /// Extract usul hadith URL from DOM element.
  ///
  /// Looks for a link ending with `?osoul=1` which indicates usul/sources.
  static String? getUsulHadithUrl(dom.Element element) {
    final anchor = element.querySelector('a[href\$="?osoul=1"]');
    return anchor?.attributes['href'];
  }

  /// Parse thematic categories (التصنيف الموضوعي) from a hadith block.
  ///
  /// Extracts category links matching `/hadith-category/cat/{id}` pattern.
  /// This matches the Node.js `parseHadithCategories()` function.
  ///
  /// Returns a list of [HadithCategory] with id and name.
  static List<HadithCategory> parseHadithCategories(dom.Element container) {
    final links = container.querySelectorAll(
      'a[href*="/hadith-category/cat/"]',
    );
    final categories = <HadithCategory>[];

    for (final link in links) {
      final href = link.attributes['href'] ?? '';
      final match = RegExp(r'/hadith-category/cat/([^/?#]+)').firstMatch(href);
      final id = match?.group(1)?.trim();
      final name = link.text.trim();
      if (id != null && id.isNotEmpty && name.isNotEmpty) {
        categories.add(HadithCategory(id: id, name: name));
      }
    }

    return categories;
  }

  /// Parse hadith metadata from a DOM element.
  ///
  /// Extracts all hadith information (rawi, mohdith, book, etc.) from
  /// the DOM structure used by Dorar.net's HTML responses.
  ///
  /// Fields are scoped by observed source labels, including optional legacy layouts.
  static ParsedHadithInfo parseHadithInfo(dom.Element infoElement) {
    final result = ParsedHadithInfo();

    // Map of field names to their Arabic labels
    final labelsMap = {
      'rawi': 'الراوي',
      'mohdith': 'المحدث',
      'book': 'المصدر',
      'numberOrPage': 'الصفحة أو الرقم',
      'grade': 'درجة الحديث',
      'explainGrade': 'خلاصة حكم المحدث',
      'takhrij': 'التخريج',
    };

    // Match labels in their own scoped nodes, never by color or position.
    final labels = labelsMap.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    for (final strong in infoElement.querySelectorAll('strong')) {
      final label = _normalizeText(strong.text);
      for (final entry in labels) {
        if (label.contains(entry.value)) {
          final span = strong.querySelector('span');
          final anchor = strong.querySelector('a');
          final value =
              span?.text ??
              anchor?.text ??
              strong.text.substring(strong.text.indexOf(':') + 1);
          result._setField(entry.key, value.trim());
          break;
        }
      }
    }
    // Quick API and embedded narration headers use label text plus siblings.
    for (final entry in labels) {
      if (result._field(entry.key).isNotEmpty) continue;
      final plain = infoElement.text;
      final pattern = RegExp(
        '${RegExp.escape(entry.value)}\\s*:\\s*([\\s\\S]*?)(?=\\s*(?:${labels.map((e) => RegExp.escape(e.value)).join('|')})\\s*:'
        r'|$)',
      );
      final match = pattern.firstMatch(plain);
      if (match != null) {
        result._setField(
          entry.key,
          match[1]!.replaceFirst(RegExp(r'[|\s]+$'), '').trim(),
        );
      }
    }

    // Extract mohdithId from link attribute
    final mohdithLink = infoElement.querySelector('a[view-card="mhd"]');
    if (mohdithLink != null) {
      final cardLink = mohdithLink.attributes['card-link'];
      if (cardLink != null) {
        final match = RegExp(r'\d+').firstMatch(cardLink);
        result.mohdithId = match?.group(0);
      }
    }

    // Extract bookId from link attribute
    final bookLink = infoElement.querySelector('a[view-card="book"]');
    if (bookLink != null) {
      final cardLink = bookLink.attributes['card-link'];
      if (cardLink != null) {
        final match = RegExp(r'\d+').firstMatch(cardLink);
        result.bookId = match?.group(0);
      }
    }

    // Extract sharhId (filter out '0' which means no sharh)
    final sharhElement = infoElement.querySelector('a[xplain]');
    if (sharhElement != null) {
      final sharhId = sharhElement.attributes['xplain'];
      if (sharhId != null && sharhId != '0') {
        result.sharhId = sharhId;
      }
    }

    // If grade is empty but explainGrade has a value, use explainGrade for grade.
    // This is because dorar.net only shows "خلاصة حكم المحدث" (explainGrade)
    // in some search results. Matches the Node.js fallback behavior.
    if (result.grade.isEmpty && result.explainGrade.isNotEmpty) {
      result.grade = result.explainGrade;
    }

    return result;
  }

  /// Normalize text for label matching.
  ///
  /// Splits on ":" and removes "|" characters, matching the Node.js implementation.
  static String _normalizeText(String text) {
    return text.split(':')[0].replaceAll('|', '').trim();
  }
}

/// Parsed hadith metadata extracted from HTML structure.
class ParsedHadithInfo {
  String rawi = '';
  String mohdith = '';
  String book = '';
  String numberOrPage = '';
  String grade = '';
  String explainGrade = '';
  String takhrij = '';
  String? mohdithId;
  String? bookId;
  String? sharhId;

  @override
  String toString() {
    return 'ParsedHadithInfo('
        'rawi: $rawi, '
        'mohdith: $mohdith, '
        'book: $book, '
        'grade: $grade'
        ')';
  }

  String _field(String name) => switch (name) {
    'rawi' => rawi,
    'mohdith' => mohdith,
    'book' => book,
    'numberOrPage' => numberOrPage,
    'grade' => grade,
    'explainGrade' => explainGrade,
    'takhrij' => takhrij,
    _ => '',
  };

  /// Internal helper to set field values by name
  void _setField(String fieldName, String value) {
    switch (fieldName) {
      case 'rawi':
        rawi = value;
        break;
      case 'mohdith':
        mohdith = value;
        break;
      case 'book':
        book = value;
        break;
      case 'numberOrPage':
        numberOrPage = value;
        break;
      case 'grade':
        grade = value;
        break;
      case 'explainGrade':
        explainGrade = value;
        break;
      case 'takhrij':
        takhrij = value;
        break;
    }
  }
}
