import '../models/result_details.dart';
import '../utils/exceptions.dart';

class ParsedCollection<T> {
  const ParsedCollection(this.items, this.diagnostics);
  final List<T> items;
  final ParseDiagnostics diagnostics;
}

/// Every recognized candidate is accounted for, including failed candidates.
ParsedCollection<T> parseCollection<E, T>(
  List<E> candidates,
  T Function(E, int) parse, {
  ParsePolicy policy = ParsePolicy.strict,
  required String stage,
  String? Function(E)? recordId,
}) {
  final items = <T>[];
  final warnings = <ParseWarning>[];
  for (var i = 0; i < candidates.length; i++) {
    try {
      items.add(parse(candidates[i], i));
    } on FormatException catch (error) {
      if (policy == ParsePolicy.strict) {
        throw DorarParseException(
          'Failed to parse $stage candidate $i: ${error.message}',
          details: {
            'stage': stage,
            'index': i,
            'recordId': recordId?.call(candidates[i]),
          },
        );
      }
      if (warnings.length < 50) {
        warnings.add(
          ParseWarning(
            stage: stage,
            index: i,
            recordId: recordId?.call(candidates[i]),
            message: error.message,
          ),
        );
      }
    }
  }
  return ParsedCollection(
    List.unmodifiable(items),
    ParseDiagnostics(
      completeness: items.length == candidates.length
          ? ParseCompleteness.complete
          : ParseCompleteness.partial,
      candidateCount: candidates.length,
      parsedCount: items.length,
      warnings: List.unmodifiable(warnings),
    ),
  );
}
