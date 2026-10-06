import 'dart:convert';
import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith/src/parsers/html_helper.dart';
import 'package:dorar_hadith/src/parsers/hadith_parser.dart';
import 'package:dorar_hadith/src/parsers/record_parser.dart';
import 'package:dorar_hadith/src/parsers/sharh_parser.dart';
import 'package:dorar_hadith/src/services/cache_service.dart';
import 'package:drift/native.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

String source(String name) =>
    (jsonDecode(File('test/fixtures/upstream/$name.json').readAsStringSync())
            as Map<String, dynamic>)['body']
        as String;
void main() {
  final expectedGrades =
      (jsonDecode(
            File('test/fixtures/upstream_expectations.json').readAsStringSync(),
          ) as Map<String, dynamic>)['grades']
          as Map<String, dynamic>;
  test('six topic pages preserve all records, glossary occurrences and relationship labels', () {
    var total = 0, glossary = 0, similar = 0, direct = 0;
    for (var topic = 0; topic < 6; topic++) {
      final blocks = HtmlHelper.parseHtml(source('search_$topic'))
          .querySelectorAll('#home .border-bottom');
      total += blocks.length;
      for (final block in blocks) {
        final record = RecordParser.parse(
          block,
          sourceUri: Uri.parse('https://dorar.net/hadith/search'),
          mode: HadithTextCleanMode.search,
        );
        expect(record.hadithId, isNotNull);
        expect(record.grade, isNotEmpty);
        for (final annotation in record.content!.annotations) {
          expect(
            annotation.range.isValidFor(record.content!.sourceText),
            isTrue,
          );
          if (annotation.kind == AnnotationKind.glossary) {
            glossary++;
            expect(
              annotation.range.extract(record.content!.sourceText),
              annotation.label,
            );
            expect(annotation.definition, isNotEmpty);
          }
        }
        if (record.explanationReference?.relationship ==
            ContentRelationship.similar) {
          similar++;
        }
        if (record.explanationReference?.relationship ==
            ContentRelationship.direct) {
          direct++;
        }
      }
    }
    expect(total, 173);
    expect(glossary, 71);
    expect(similar, 85);
    expect(direct, 2);
  });
  test('all audited explanation headers keep exact grades and independent citations', () {
    for (final entry in expectedGrades.entries) {
      final parsed = SharhParser.parseSharhPage(
        source('sharh_${entry.key}'),
        entry.key,
      );
      expect(parsed.grade, entry.value, reason: entry.key);
      expect(parsed.record.hadithId, isNotNull);
      expect(parsed.record.categories, isNotEmpty);
      for (final block in parsed.document.blocks) {
        expect(block.range.isValidFor(parsed.document.sourceText), isTrue);
      }
    }
    final parsed = SharhParser.parseSharhPage(source('sharh_137940'), '137940');
    expect(parsed.record.mohdith, 'شعيب الأرناؤوط');
    final embedded = parsed.document.blocks
        .where((b) => b.citation != null)
        .first
        .citation!;
    expect(embedded.source, 'صحيح أبي داود');
    expect(parsed.document.commentaryText, contains('القِيامُ'));
    expect(parsed.document.commentaryText, isNot(contains('الراوي :')));
  });
  test('quran labels and destinations are preserved without deriving ayah from URL', () {
    for (final id in ['114935', '226191', '2065']) {
      final parsed = SharhParser.parseSharhPage(source('sharh_$id'), id);
      final citations = parsed.document.annotations.where(
        (a) => a.kind == AnnotationKind.quranCitation,
      );
      expect(citations, isNotEmpty, reason: id);
      for (final a in citations) {
        expect(a.range.extract(parsed.document.sourceText), a.label);
        expect(a.uri!.path, startsWith('/tafseer/'));
      }
    }
  });
  test('paragraphs and markup attributes survive; safe rendering removes executable links', () {
    final document = DocumentParser.parse(
      '<p>First - sentence <a class="hist-link" data-content="a - definition">term</a></p><p>Second<br>line <a href="javascript:alert(1)">link</a></p>',
    );
    expect(document.plainText, contains('First - sentence'));
    expect(document.plainText, contains('\n\nSecond\nline'));
    expect(document.sourceHtml, contains('data-content'));
    expect(renderDocumentHtml(document), isNot(contains('javascript:')));
    expect(
      SourcedDocument.fromJson(document.toJson()).sourceText,
      document.sourceText,
    );
  });
  test('reviewed attribution validates hash, evidence, source and surrogate-safe ranges', () {
    final uri = Uri.parse('https://dorar.net/hadith/sharh/2065');
    final document = DocumentParser.parse('قال 😀', sourceUri: uri);
    final valid = AttributionAnnotation(
      range: const TextRange(0, 3),
      role: SpeakerRole.unknown,
      evidence: AttributionEvidence.reviewed,
      documentHash: document.contentHash,
      sourceUri: uri,
      reviewer: 'fixture review',
      evidenceNote: 'Synthetic range validation',
    );
    expect(() => document.validateAttributions([valid]), returnsNormally);
    final bad = AttributionAnnotation(
      range: const TextRange(5, 6),
      role: SpeakerRole.prophet,
      evidence: AttributionEvidence.reviewed,
      documentHash: 'stale',
      sourceUri: uri,
      reviewer: 'fixture review',
      evidenceNote: 'Synthetic counterexample',
    );
    expect(() => document.validateAttributions([bad]), throwsArgumentError);
  });
  group('actual services against captured raw sources', () {
    late CacheService cache;
    late DorarHttpClient http;
    setUp(() {
      cache = CacheService(database: CacheDatabase(NativeDatabase.memory()));
      http = DorarHttpClient(
        client: MockClient((request) async {
          final uri = request.url;
          String name;
          if (uri.path.startsWith('/hadith/sharh/')) {
            name = 'sharh_${uri.pathSegments.last}';
          } else if (uri.path == '/dorar_api.json') {
            name = 'empty_${uri.queryParameters['skey']}';
          } else if (uri.queryParameters['alts'] == '1') {
            name = 'alternates_${uri.pathSegments.last}';
          } else if (uri.queryParameters['osoul'] == '1') {
            name = 'usul_${uri.pathSegments.last}';
          } else if (uri.queryParameters['asbab'] == '1') {
            name = 'asbab_${uri.pathSegments.last}';
          } else if (uri.path.startsWith('/hadith-category/cat/')) {
            name =
                'category_${uri.pathSegments.last}_${uri.queryParameters['page']}';
          } else if (uri.queryParameters['t'] == '3') {
            name = 'prose_0';
          } else {
            name = 'search_0';
          }
          return createUtf8Response(source(name), 200);
        }),
      );
    });
    tearDown(() async {
      http.dispose();
      await cache.dispose();
    });
    test(
      'all 31 alternate records are retained, not just one per source',
      () async {
        final service = HadithService(client: http, cache: cache);
        var count = 0;
        for (final id in [
          'i9N1PTUu',
          'BRpyQaPP',
          'Q0jZhzCM',
          'is6eZe9m',
          'WYtt5aj3',
          'QXETlI6C',
          'vG9L36PK',
          '6y6pYWK6',
          'Q3GV55o5',
          'QPQEXsVj',
          'RKi1asJG',
          'O7sx39P0',
          'kHeZ3ULL',
          'Kw3L9vhK',
          'DMyQ3Zkn',
          'VGfHSGLl',
        ]) {
          final result = await service.getAlternates(id);
          expect(result.data.source!.hadithId, id);
          count += result.data.related.length;
        }
        expect(count, 31);
      },
    );
    test('empty quick searches are successful', () async {
      final service = HadithService(client: http, cache: cache);
      for (final query in ['zxqvnrplm', 'wqzxvnrplm']) {
        expect(
          (await service.searchViaApi(HadithSearchParams(value: query))).data,
          isEmpty,
        );
      }
    });
    test('no-source usul does not fabricate advertised availability', () async {
      final result = await HadithService(
        client: http,
        cache: cache,
      ).getUsul('61NF8fB7');
      expect(result.data.sources, isEmpty);
      expect(result.data.hadith.hasUsulHadith, isFalse);
    });
    test('context citation remains distinct from requested record', () async {
      final result = await HadithService(
        client: http,
        cache: cache,
      ).getAsbab('wcyAMgeR');
      expect(result.data.narrations, isNotEmpty);
      expect(result.data.narrations.first.hadith.hadithId, '7L9WUmLZ');
    });
    test(
      'category page eleven is served, ordinary search page eleven is rejected',
      () async {
        final service = CategoryService(client: http, cache: cache);
        final result = await service.browse(
          CategoryBrowseParams(
            categoryId: CategoryId('f274e082cc20c93e2d217355f9ee05d4'),
            page: 11,
          ),
        );
        expect(result.data.length, 20);
        expect(result.metadata.pagination!.accessiblePageLimit, isNull);
        expect(
          () => HadithService(
            client: http,
            cache: cache,
          ).searchViaSite(const HadithSearchParams(value: 'الصلاة', page: 11)),
          throwsA(isA<DorarValidationException>()),
        );
      },
    );
    test('explanation prose parses snippets without ordinary tabs', () async {
      final result = await SharhService(
        client: http,
        cache: cache,
      ).searchText(const SharhTextSearchParams(value: 'الصلاة'));
      expect(result.data.length, 15);
      expect(result.data.first.id, '30218');
    });
    test(
      'plain, html and structured explanation requests share correct raw cache',
      () async {
        final service = SharhService(client: http, cache: cache);
        for (final id in ['137940', '2981']) {
          final plain = await service.getById(id);
          final html = await service.getById(id, removeHtml: false);
          expect(html.sharhText, contains('<'));
          expect(plain.sharhText, isNot(html.sharhText));
          expect(html.document!.contentHash, plain.document!.contentHash);
          expect(html.provenance!.isCached, isTrue);
        }
      },
    );
  });
}
