import 'source_content.dart';

/// A source substring for custom renderers. Speaker is absent without confirmed evidence.
class RenderToken {
  const RenderToken({
    required this.range,
    required this.text,
    required this.blockKind,
    this.annotations = const [],
    this.attribution,
  });
  final TextRange range;
  final String text;
  final BlockKind blockKind;
  final List<InlineAnnotation> annotations;
  final AttributionAnnotation? attribution;
}

/// Split at structural and annotation boundaries without normalizing wording.
List<RenderToken> documentRenderTokens(
  SourcedDocument document, {
  List<AttributionAnnotation> reviewedAttributions = const [],
  bool commentaryOnly = false,
}) {
  document.validateAttributions(reviewedAttributions);
  final tokens = <RenderToken>[];
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
    final annotations = document.annotations
        .where(
          (a) =>
              a.range.start < block.range.end &&
              a.range.end > block.range.start,
        )
        .toList();
    final attributions = reviewedAttributions
        .where(
          (a) =>
              a.isConfirmed &&
              a.range.start < block.range.end &&
              a.range.end > block.range.start,
        )
        .toList();
    final boundaries = <int>{block.range.start, block.range.end};
    for (final range in [
      ...annotations.map((a) => a.range),
      ...attributions.map((a) => a.range),
    ]) {
      if (!range.isValidFor(document.sourceText)) {
        throw ArgumentError('Invalid annotation range');
      }
      boundaries.add(range.start.clamp(block.range.start, block.range.end));
      boundaries.add(range.end.clamp(block.range.start, block.range.end));
    }
    final ordered = boundaries.toList()..sort();
    if (block.kind == BlockKind.separator) {
      tokens.add(
        RenderToken(range: block.range, text: '', blockKind: block.kind),
      );
    }
    for (var i = 1; i < ordered.length; i++) {
      final range = TextRange(ordered[i - 1], ordered[i]);
      tokens.add(
        RenderToken(
          range: range,
          text: range.extract(document.sourceText),
          blockKind: block.kind,
          annotations: List.unmodifiable(
            annotations.where(
              (a) => a.range.start <= range.start && a.range.end >= range.end,
            ),
          ),
          attribution: attributions
              .where(
                (a) => a.range.start <= range.start && a.range.end >= range.end,
              )
              .firstOrNull,
        ),
      );
    }
  }
  return List.unmodifiable(tokens);
}
