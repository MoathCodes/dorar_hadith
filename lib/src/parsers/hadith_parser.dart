import 'package:html/dom.dart' as dom;

/// Utilities for parsing hadith information from HTML DOM elements.
///
/// This replicates the parsing logic from the Node.js version's
/// `parseHadithInfo.js` file, using the same selectors and logic.
class HadithParser {
  HadithParser._();

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
    return anchor?.attributes['tag'];
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

  /// Parse hadith metadata from a DOM element.
  ///
  /// Extracts all hadith information (rawi, mohdith, book, etc.) from
  /// the DOM structure used by Dorar.net's HTML responses.
  ///
  /// This matches the Node.js `parseHadithInfo()` function exactly.
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

    // Get all <strong> elements that contain labels
    final strongElements = infoElement.querySelectorAll('strong');

    for (final strong in strongElements) {
      final label = _normalizeText(strong.text);

      // Check each label to see if it matches
      // We iterate in a specific order to handle overlapping labels correctly
      // (e.g., "المحدث" is contained in "خلاصة حكم المحدث", so we check the longer one first)
      final labelsToCheck = [
        MapEntry('explainGrade', labelsMap['explainGrade']!),
        MapEntry('rawi', labelsMap['rawi']!),
        MapEntry('mohdith', labelsMap['mohdith']!),
        MapEntry('book', labelsMap['book']!),
        MapEntry('numberOrPage', labelsMap['numberOrPage']!),
        MapEntry('grade', labelsMap['grade']!),
        MapEntry('takhrij', labelsMap['takhrij']!),
      ];

      for (final entry in labelsToCheck) {
        if (label.contains(entry.value)) {
          // Extract value from <span> inside <strong>
          final span = strong.querySelector('span');
          if (span != null) {
            final value = span.text.trim();
            result._setField(entry.key, value);
            break; // Stop after first match to avoid overlapping labels
          }
        }
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
