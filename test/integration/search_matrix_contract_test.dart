import 'dart:convert';
import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith/src/services/cache_service.dart';
import 'package:drift/native.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

String source(String name) =>
    jsonDecode(
          File('test/fixtures/upstream/$name.json').readAsStringSync(),
        )['body']
        as String;
void main() {
  late CacheService cache;
  late DorarHttpClient http;
  late HadithService service;
  late String responseName;
  setUp(() {
    cache = CacheService(database: CacheDatabase(NativeDatabase.memory()));
    http = DorarHttpClient(
      client: MockClient(
        (r) async => createUtf8Response(source(responseName), 200),
      ),
    );
    service = HadithService(client: http, cache: cache);
  });
  tearDown(() async {
    http.dispose();
    await cache.dispose();
  });
  test('two-topic phrase matrix, every ordinary type and sort layout parse strictly', () async {
    for (var topic = 0; topic < 2; topic++) {
      final query = topic == 0 ? 'الصلاة' : 'الصيام';
      for (final name in [
        'primary',
        'optional',
        'mismatch',
        'two',
        'three',
        'four',
        'blank',
        'all',
        'any',
        'exact',
        'exclude',
        'specialist',
      ]) {
        responseName = 'phrase_matrix_${topic}_$name';
        // Unique local URI isolates captures while exercising the real layout parser.
        final result = await service.searchSiteUrl(
          'https://dorar.net/hadith/search?fixture=$responseName',
          page: 1,
          specialist: name == 'specialist',
        );
        expect(
          result.metadata.diagnostics!.completeness,
          ParseCompleteness.complete,
          reason: responseName,
        );
        expect(result.metadata.diagnostics!.candidateCount, result.data.length);
      }
      for (final type in HadithTypeFilter.values) {
        responseName = 'type_${topic}_${type.id}';
        final result = await service.searchViaSite(
          HadithSearchParams(value: query, types: {type}),
        );
        expect(
          result.metadata.diagnostics!.completeness,
          ParseCompleteness.complete,
        );
        expect(result.metadata.pagination!.accessiblePageLimit, 10);
      }
      responseName = 'sort_$topic';
      final sorted = await service.searchViaSite(
        HadithSearchParams(value: query, sort: HadithSort.degree),
      );
      expect(sorted.data, isNotEmpty);
      expect(sorted.metadata.pagination!.displayedTotal, greaterThan(300));
    }
  });
  test('quick matrix parses supported filters and does not invent identifiers or totals', () async {
    for (var topic = 0; topic < 2; topic++) {
      for (final filter in [
        'default',
        'degree',
        'scholar',
        'book',
        'exclude_specific',
        'method_specific',
      ]) {
        responseName = 'quick_matrix_${topic}_$filter';
        final result = await service.searchViaApi(
          HadithSearchParams(value: 'fixture $responseName'),
        );
        expect(result.data, hasLength(15));
        expect(result.metadata.total, isNull);
        expect(
          result.metadata.pagination!.nextPageEvidence,
          NextPageEvidence.pageSizeHint,
        );
      }
    }
  });
  test(
    'valid empty alternative layouts return null and preserve the seed',
    () async {
      for (var topic = 0; topic < 2; topic++) {
        responseName = 'empty_alternates_$topic';
        final captured = jsonDecode(
          File('test/fixtures/upstream/$responseName.json').readAsStringSync(),
        ) as Map<String, dynamic>;
        final id = Uri.parse(captured['url'] as String).pathSegments.last;
        final result = await service.getAlternates(id);
        expect(result.data.source!.hadithId, id);
        expect(result.data.related, isEmpty);
        expect(await service.getAlternate(id), isNull);
      }
    },
  );
  test('unsupported quick filters are rejected before transport, typed site IDs serialize canonically', () async {
    var requests = 0;
    http.dispose();
    http = DorarHttpClient(
      client: MockClient((r) async {
        requests++;
        throw StateError('Unexpected request');
      }),
    );
    service = HadithService(client: http, cache: cache);
    for (final params in [
      const HadithSearchParams(
        value: 'الصلاة',
        types: {HadithTypeFilter.marfoo},
      ),
      HadithSearchParams(
        value: 'الصلاة',
        narratorChoiceIds: [NarratorChoiceId('1633')],
      ),
      const HadithSearchParams(value: 'الصلاة', sort: HadithSort.degree),
      const HadithSearchParams(value: 'الصلاة', zone: SearchZone.sharh),
    ]) {
      await expectLater(
        service.searchViaApi(params),
        throwsA(isA<DorarValidationException>()),
      );
    }
    expect(requests, 0);
    final encoded = QuerySerializer.serializeHadithParams(
      HadithSearchParams(
        value: 'صلاة & ؟ # +',
        scholarIds: [ScholarId('256'), ScholarId('1420'), ScholarId('256')],
        bookIds: [BookId('6216')],
        narratorChoiceIds: [NarratorChoiceId('1633')],
        optionalPhrases: ['', 'الصيام'],
      ),
    );
    expect(encoded['m'], ['1420', '256']);
    expect(encoded['optional_phrase1'], isNull);
    expect(encoded['optional_phrase2'], 'الصيام');
    final uri = Uri.parse(
      QuerySerializer.buildUrl('https://dorar.net/hadith/search', encoded),
    );
    expect(uri.queryParameters['q'], 'صلاة & ؟ # +');
  });
}
