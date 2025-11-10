import 'exceptions.dart';

/// Validation utilities for Dorar API inputs.
class Validators {
  /// Maximum allowed length for search text
  static const int maxSearchTextLength = 500;

  /// Minimum page number
  static const int minPage = 1;

  /// Maximum page number
  static const int maxPage = 1000;

  Validators._(); // Private constructor to prevent instantiation

  /// Validates book ID format.
  ///
  /// Book IDs should be numeric strings.
  ///
  /// Throws [DorarValidationException] if invalid.
  static String validateBookId(String? id) {
    if (id == null || id.trim().isEmpty) {
      throw const DorarValidationException(
        'Book ID is required',
        field: 'bookId',
        rule: 'required',
      );
    }

    final trimmed = id.trim();
    final pattern = RegExp(r'^\d+$');

    if (!pattern.hasMatch(trimmed)) {
      throw DorarValidationException(
        'Invalid book ID format. Must be numeric',
        field: 'bookId',
        rule: 'numeric',
        details: {'value': trimmed},
      );
    }

    return trimmed;
  }

  /// Validates hadith ID format.
  ///
  /// Hadith IDs can contain alphanumeric characters, hyphens and underscores.
  /// Based on real API data, valid IDs include: 'j0j8uiR3', 'BRpyQaPP', etc.
  ///
  /// Throws [DorarValidationException] if invalid.
  static String validateHadithId(String? id) {
    if (id == null || id.trim().isEmpty) {
      throw const DorarValidationException(
        'Hadith ID is required',
        field: 'hadithId',
        rule: 'required',
      );
    }

    final trimmed = id.trim();
    final pattern = RegExp(r'^[0-9a-zA-Z\-_]+$');

    if (!pattern.hasMatch(trimmed)) {
      throw DorarValidationException(
        'Invalid hadith ID format. Only alphanumeric characters, hyphens, and underscores are allowed',
        field: 'hadithId',
        rule: 'format',
        details: {'value': trimmed},
      );
    }

    return trimmed;
  }

  /// Validates mohdith ID format.
  ///
  /// Mohdith IDs should be numeric strings.
  ///
  /// Throws [DorarValidationException] if invalid.
  static String validateMohdithId(String? id) {
    if (id == null || id.trim().isEmpty) {
      throw const DorarValidationException(
        'Mohdith ID is required',
        field: 'mohdithId',
        rule: 'required',
      );
    }

    final trimmed = id.trim();
    final pattern = RegExp(r'^\d+$');

    if (!pattern.hasMatch(trimmed)) {
      throw DorarValidationException(
        'Invalid mohdith ID format. Must be numeric',
        field: 'mohdithId',
        rule: 'numeric',
        details: {'value': trimmed},
      );
    }

    return trimmed;
  }

  /// Validates page number.
  ///
  /// Throws [DorarValidationException] if:
  /// - Page is less than 1
  /// - Page exceeds maximum
  ///
  /// Returns the page number if valid.
  static int validatePage(int page) {
    if (page < minPage) {
      throw DorarValidationException(
        'Page number must be at least $minPage',
        field: 'page',
        rule: 'min',
        details: {'value': page, 'min': minPage},
      );
    }

    if (page > maxPage) {
      throw DorarValidationException(
        'Page number cannot exceed $maxPage',
        field: 'page',
        rule: 'max',
        details: {'value': page, 'max': maxPage},
      );
    }

    return page;
  }

  /// Validates search query text.
  ///
  /// Throws [DorarValidationException] if:
  /// - Text is null or empty
  /// - Text exceeds maximum length
  ///
  /// Returns the trimmed text if valid.
  static String validateSearchText(String? text, {String field = 'value'}) {
    if (text == null || text.trim().isEmpty) {
      throw DorarValidationException(
        'Search text is required',
        field: field,
        rule: 'required',
      );
    }

    final trimmed = text.trim();

    if (trimmed.length > maxSearchTextLength) {
      throw DorarValidationException(
        'Search text is too long (max: $maxSearchTextLength characters)',
        field: field,
        rule: 'maxLength',
        details: {'length': trimmed.length, 'max': maxSearchTextLength},
      );
    }

    return trimmed;
  }

  /// Validates sharh ID format.
  ///
  /// Sharh IDs should be numeric strings.
  ///
  /// Throws [DorarValidationException] if invalid.
  static String validateSharhId(String? id) {
    if (id == null || id.trim().isEmpty) {
      throw const DorarValidationException(
        'Sharh ID is required',
        field: 'sharhId',
        rule: 'required',
      );
    }

    final trimmed = id.trim();
    final pattern = RegExp(r'^\d+$');

    if (!pattern.hasMatch(trimmed)) {
      throw DorarValidationException(
        'Invalid sharh ID format. Must be numeric',
        field: 'sharhId',
        rule: 'numeric',
        details: {'value': trimmed},
      );
    }

    return trimmed;
  }

  /// Validates a timeout duration.
  ///
  /// Throws [DorarValidationException] if invalid.
  static Duration validateTimeout(Duration? timeout) {
    if (timeout == null) {
      throw const DorarValidationException(
        'Timeout cannot be null',
        field: 'timeout',
        rule: 'required',
      );
    }

    if (timeout.inMilliseconds <= 0) {
      throw DorarValidationException(
        'Timeout must be positive',
        field: 'timeout',
        rule: 'positive',
        details: {'value': timeout.inMilliseconds},
      );
    }

    if (timeout.inSeconds > 300) {
      // 5 minutes max
      throw DorarValidationException(
        'Timeout cannot exceed 5 minutes',
        field: 'timeout',
        rule: 'max',
        details: {'value': timeout.inSeconds, 'max': 300},
      );
    }

    return timeout;
  }

  /// Validates a URL string.
  ///
  /// Throws [DorarValidationException] if invalid.
  static String validateUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      throw const DorarValidationException(
        'URL cannot be empty',
        field: 'url',
        rule: 'required',
      );
    }

    final trimmed = url.trim();

    try {
      final uri = Uri.parse(trimmed);
      if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
        throw const DorarValidationException(
          'URL must have http or https scheme',
          field: 'url',
          rule: 'scheme',
        );
      }
      return trimmed;
    } catch (e) {
      throw DorarValidationException(
        'Invalid URL format',
        field: 'url',
        rule: 'format',
        details: {'value': trimmed, 'error': e.toString()},
      );
    }
  }
}
