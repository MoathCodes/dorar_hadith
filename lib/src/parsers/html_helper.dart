import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

/// Utilities for parsing HTML documents from Dorar.net responses.
///
/// Provides a wrapper around the html package with helper methods
/// for common parsing operations.
class HtmlHelper {
  HtmlHelper._();

  /// Extract all text from element and descendants.
  static String extractAllText(dom.Element element) {
    return element.text.trim();
  }

  /// Get attribute value from an element, or null if not found.
  static String? getAttribute(dom.Element? element, String attributeName) {
    return element?.attributes[attributeName];
  }

  /// Get element by ID.
  static dom.Element? getElementById(dom.Document document, String id) {
    return document.getElementById(id);
  }

  /// Get elements by class name.
  static List<dom.Element> getElementsByClassName(
    dom.Element element,
    String className,
  ) {
    return element.querySelectorAll('.$className');
  }

  /// Get inner HTML of an element.
  static String getInnerHtml(dom.Element element) {
    return element.innerHtml;
  }

  /// Get next sibling element (skipping text nodes).
  static dom.Element? getNextElementSibling(dom.Element element) {
    var next = element.nextElementSibling;
    while (next != null && next.nodeType != dom.Node.ELEMENT_NODE) {
      next = next.nextElementSibling;
    }
    return next;
  }

  /// Get previous sibling element (skipping text nodes).
  static dom.Element? getPreviousElementSibling(dom.Element element) {
    var prev = element.previousElementSibling;
    while (prev != null && prev.nodeType != dom.Node.ELEMENT_NODE) {
      prev = prev.previousElementSibling;
    }
    return prev;
  }

  /// Get text content from an element, or empty string if null.
  static String getTextContent(dom.Element? element) {
    return element?.text.trim() ?? '';
  }

  /// Check if element has a specific class.
  static bool hasClass(dom.Element element, String className) {
    return element.classes.contains(className);
  }

  /// Parse HTML fragment (partial HTML without full document structure).
  static dom.DocumentFragment parseFragment(String htmlString) {
    return html_parser.parseFragment(htmlString);
  }

  /// Parse HTML string into a DOM document.
  ///
  /// This is the main entry point for converting HTML responses
  /// into queryable DOM structures.
  static dom.Document parseHtml(String htmlString) {
    return html_parser.parse(htmlString);
  }

  /// Query selector that returns null instead of throwing on invalid selector.
  static dom.Element? querySelector(dom.Element element, String selector) {
    try {
      return element.querySelector(selector);
    } catch (e) {
      return null;
    }
  }

  /// Query selector all that returns empty list on error.
  static List<dom.Element> querySelectorAll(
    dom.Element element,
    String selector,
  ) {
    try {
      return element.querySelectorAll(selector);
    } catch (e) {
      return [];
    }
  }
}
