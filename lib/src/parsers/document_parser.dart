import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;

import '../models/source_content.dart';

/// Extracts DOM structure without changing religious wording or guessing speakers.
class DocumentParser {
  static SourcedDocument parse(
    String fragment, {
    Uri? sourceUri,
    BlockKind defaultKind = BlockKind.paragraph,
    Citation? embeddedCitation,
  }) {
    final root = html.parseFragment(fragment);
    final builder = _DocumentBuilder(sourceUri, defaultKind, embeddedCitation);
    for (final node in root.nodes) {
      builder.visit(node);
    }
    builder.flush(defaultKind);
    final text = builder.text.toString();
    // Quotation punctuation establishes a quotation span, never its speaker.
    for (final match in RegExp(
      r'«[^«»]+»|“[^“”]+”|"[^"\n]+"',
    ).allMatches(text)) {
      builder.annotations.add(
        InlineAnnotation(
          kind: AnnotationKind.quotation,
          range: TextRange(match.start, match.end),
          label: match[0],
          evidence: 'balancedQuotationPunctuation',
        ),
      );
    }
    return SourcedDocument(
      sourceUri: sourceUri,
      sourceHtml: fragment,
      sourceText: text,
      contentHash: sha256.convert(utf8.encode('1\n$text')).toString(),
      blocks: List.unmodifiable(builder.blocks),
      annotations: List.unmodifiable(builder.annotations),
    );
  }
}

class _DocumentBuilder {
  _DocumentBuilder(this.sourceUri, this.defaultKind, this.embeddedCitation);
  final Uri? sourceUri;
  final BlockKind defaultKind;
  final Citation? embeddedCitation;
  final text = StringBuffer();
  final blocks = <DocumentBlock>[];
  final annotations = <InlineAnnotation>[];
  int blockStart = 0;
  bool beforeSeparator = true;
  static const containers = {
    'div',
    'article',
    'section',
    'p',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'li',
    'ul',
    'ol',
  };
  void flush(BlockKind kind, {Citation? citation}) {
    if (text.length <= blockStart) return;
    final value = text.toString().substring(blockStart);
    if (value.trim().isEmpty) return;
    blocks.add(
      DocumentBlock(
        kind: kind,
        range: TextRange(blockStart, text.length),
        citation: citation,
      ),
    );
    text.write('\n\n');
    blockStart = text.length;
  }

  void visit(dom.Node node, {BlockKind? currentKind}) {
    final kind = currentKind ?? defaultKind;
    if (node is dom.Text) {
      // Ignore indentation between structural blocks, preserve inline spacing.
      if (node.data.trim().isEmpty && text.length == blockStart) return;
      text.write(node.data);
      return;
    }
    if (node is! dom.Element ||
        {'script', 'style', 'button', 'noscript'}.contains(node.localName)) {
      return;
    }
    if (node.localName == 'hr') {
      flush(kind);
      blocks.add(
        DocumentBlock(
          kind: BlockKind.separator,
          range: TextRange(text.length, text.length),
        ),
      );
      beforeSeparator = false;
      return;
    }
    if (node.localName == 'br') {
      text.write('\n');
      return;
    }
    var childKind = kind;
    if (node.classes.contains('app-hadith-info') ||
        (beforeSeparator &&
            node.localName == 'p' &&
            node.text.trimLeft().startsWith('التخريج'))) {
      childKind = BlockKind.citation;
    } else if (beforeSeparator &&
        embeddedCitation != null &&
        node.localName == 'div' &&
        node.querySelector('.app-hadith-info') == null &&
        node.parent?.querySelector('.app-hadith-info') != null) {
      childKind = BlockKind.narration;
    } else if (node.localName == 'li') {
      childKind = BlockKind.listItem;
    } else if (RegExp(r'^h[1-6]$').hasMatch(node.localName ?? '')) {
      childKind = kind == BlockKind.narration ? kind : BlockKind.heading;
    }
    final block = containers.contains(node.localName);
    if (block) flush(kind);
    final start = text.length;
    for (final child in node.nodes) {
      visit(child, currentKind: childKind);
    }
    final end = text.length;
    if (node.localName == 'a') {
      final definition = node.attributes['data-content'];
      final href = node.attributes['href'];
      final uri = href == null
          ? null
          : (sourceUri ?? Uri.parse('https://dorar.net')).resolve(href);
      final glossary = node.classes.contains('hist-link') && definition != null;
      final quran = uri?.path.startsWith('/tafseer/') == true;
      if (glossary || (uri != null && end > start)) {
        annotations.add(
          InlineAnnotation(
            kind: glossary
                ? AnnotationKind.glossary
                : quran
                ? AnnotationKind.quranCitation
                : AnnotationKind.link,
            range: TextRange(start, end),
            label: node.text,
            uri: uri,
            quranReference: quran
                ? QuranCitationReference.parseLabel(node.text)
                : null,
            definition: definition == null
                ? null
                : html.parseFragment(definition).text,
            definitionHtml: definition,
          ),
        );
      }
    }
    if (block) {
      flush(
        childKind,
        citation:
            childKind == BlockKind.narration || childKind == BlockKind.citation
            ? embeddedCitation
            : null,
      );
    }
  }
}

/// Safe semantic HTML generated from text and allowlisted source annotations.
/// Original HTML is available separately and is not implicitly safe to embed.
String renderDocumentHtml(
  SourcedDocument document, {
  bool commentaryOnly = false,
}) {
  document.validate();
  const escape = HtmlEscape(HtmlEscapeMode.element);
  const attr = HtmlEscape(HtmlEscapeMode.attribute);
  final out = StringBuffer();
  for (final block in document.blocks) {
    if (commentaryOnly &&
        {
          BlockKind.narration,
          BlockKind.citation,
          BlockKind.chain,
          BlockKind.separator,
        }.contains(block.kind)) {
      continue;
    }
    if (block.kind == BlockKind.separator) {
      out.write('<hr>');
      continue;
    }
    final tag = block.kind == BlockKind.heading ? 'h3' : 'p';
    out.write('<$tag>');
    var cursor = block.range.start;
    final inline =
        document.annotations
            .where(
              (a) =>
                  a.kind != AnnotationKind.quotation &&
                  a.range.start >= cursor &&
                  a.range.end <= block.range.end,
            )
            .toList()
          ..sort((a, b) => a.range.start.compareTo(b.range.start));
    for (final annotation in inline) {
      if (annotation.range.start < cursor) continue;
      out.write(
        escape
            .convert(
              document.sourceText.substring(cursor, annotation.range.start),
            )
            .replaceAll('\n', '<br>'),
      );
      final label = escape.convert(
        annotation.range.extract(document.sourceText),
      );
      final uri = annotation.uri;
      if (annotation.kind == AnnotationKind.glossary) {
        out.write(
          '<span title="${attr.convert(annotation.definition ?? '')}">$label</span>',
        );
      } else if (uri != null && {'http', 'https'}.contains(uri.scheme)) {
        out.write('<a href="${attr.convert(uri.toString())}">$label</a>');
      } else {
        out.write(label);
      }
      cursor = annotation.range.end;
    }
    out.write(
      escape
          .convert(document.sourceText.substring(cursor, block.range.end))
          .replaceAll('\n', '<br>'),
    );
    out.write('</$tag>');
  }
  return out.toString();
}
