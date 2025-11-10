import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('QuerySerializer', () {
    group('serializeHadithParams()', () {
      test('should use "q" for site endpoint search text', () {
        final params = HadithSearchParams(value: 'الصلاة');
        final serialized = QuerySerializer.serializeHadithParams(
          params,
          isApiEndpoint: false,
        );

        expect(serialized['q'], equals('الصلاة'));
        expect(serialized['skey'], isNull);
      });

      test('should use "skey" for API endpoint search text', () {
        final params = HadithSearchParams(value: 'الصلاة');
        final serialized = QuerySerializer.serializeHadithParams(
          params,
          isApiEndpoint: true,
        );

        expect(serialized['skey'], equals('الصلاة'));
        expect(serialized['q'], isNull);
      });

      test('should include page number for both endpoints', () {
        final params = HadithSearchParams(value: 'test', page: 5);

        final site = QuerySerializer.serializeHadithParams(
          params,
          isApiEndpoint: false,
        );
        final api = QuerySerializer.serializeHadithParams(
          params,
          isApiEndpoint: true,
        );

        expect(site['page'], equals(5));
        expect(api['page'], equals(5));
      });

      test(
        'should serialize exclude parameter with same key for both endpoints',
        () {
          final params = HadithSearchParams(value: 'الصلاة', exclude: 'كلمة');

          final site = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: false,
          );
          final api = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: true,
          );

          expect(site['xclude'], equals('كلمة'));
          expect(api['xclude'], equals('كلمة'));
        },
      );

      test(
        'should serialize search method with same key for both endpoints',
        () {
          final params = HadithSearchParams(
            value: 'test',
            searchMethod: SearchMethod.allWords,
          );

          final site = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: false,
          );
          final api = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: true,
          );

          expect(site['st'], equals(SearchMethod.allWords.id));
          expect(api['st'], equals(SearchMethod.allWords.id));
        },
      );

      test(
        'should use "t" for zone parameter for BOTH endpoints (not "grp")',
        () {
          final params = HadithSearchParams(
            value: 'test',
            zone: SearchZone.qudsi,
          );

          final site = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: false,
          );
          final api = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: true,
          );

          // Both should use 't', not 'grp'
          expect(site['t'], equals(SearchZone.qudsi.id));
          expect(api['t'], equals(SearchZone.qudsi.id));
          expect(api['grp'], isNull, reason: 'API should NOT use "grp" key');
        },
      );

      test(
        'should use "d" for degrees parameter for BOTH endpoints (not "rad")',
        () {
          final params = HadithSearchParams(
            value: 'test',
            degrees: [HadithDegree.authenticHadith],
          );

          final site = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: false,
          );
          final api = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: true,
          );

          // Both should use 'd', not 'rad'
          expect(site['d'], equals([HadithDegree.authenticHadith.id]));
          expect(api['d'], equals([HadithDegree.authenticHadith.id]));
          expect(api['rad'], isNull, reason: 'API should NOT use "rad" key');
        },
      );

      test(
        'should use "m" for mohdith parameter for BOTH endpoints (not "tr")',
        () {
          final params = HadithSearchParams(
            value: 'test',
            mohdith: [MohdithReference.bukhari],
          );

          final site = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: false,
          );
          final api = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: true,
          );

          // Both should use 'm', not 'tr'
          expect(site['m'], equals([MohdithReference.bukhari.id]));
          expect(api['m'], equals([MohdithReference.bukhari.id]));
          expect(api['tr'], isNull, reason: 'API should NOT use "tr" key');
        },
      );

      test(
        'should use "s" for books parameter for BOTH endpoints (not "mhd")',
        () {
          final params = HadithSearchParams(
            value: 'test',
            books: [BookReference.sahihBukhari],
          );

          final site = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: false,
          );
          final api = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: true,
          );

          // Both should use 's', not 'mhd'
          expect(site['s'], equals([BookReference.sahihBukhari.id]));
          expect(api['s'], equals([BookReference.sahihBukhari.id]));
          expect(api['mhd'], isNull, reason: 'API should NOT use "mhd" key');
        },
      );

      test(
        'should serialize rawi parameter with same key for both endpoints',
        () {
          final params = HadithSearchParams(
            value: 'test',
            rawi: [RawiReference.abuHurayrah],
          );

          final site = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: false,
          );
          final api = QuerySerializer.serializeHadithParams(
            params,
            isApiEndpoint: true,
          );

          expect(site['rawi'], equals([RawiReference.abuHurayrah.id]));
          expect(api['rawi'], equals([RawiReference.abuHurayrah.id]));
        },
      );

      test('should handle multiple degrees correctly', () {
        final params = HadithSearchParams(
          value: 'test',
          degrees: [HadithDegree.authenticHadith, HadithDegree.authenticChain],
        );

        final serialized = QuerySerializer.serializeHadithParams(
          params,
          isApiEndpoint: true,
        );

        expect(
          serialized['d'],
          equals([
            HadithDegree.authenticHadith.id,
            HadithDegree.authenticChain.id,
          ]),
        );
      });

      test('should handle multiple books correctly', () {
        final params = HadithSearchParams(
          value: 'test',
          books: [BookReference.sahihBukhari, BookReference.sahihMuslim],
        );

        final serialized = QuerySerializer.serializeHadithParams(
          params,
          isApiEndpoint: true,
        );

        expect(
          serialized['s'],
          equals([BookReference.sahihBukhari.id, BookReference.sahihMuslim.id]),
        );
      });

      test('should omit null or empty optional parameters', () {
        final params = HadithSearchParams(value: 'test');
        final serialized = QuerySerializer.serializeHadithParams(params);

        expect(serialized['xclude'], isNull);
        expect(serialized['st'], isNull);
        expect(serialized['t'], isNull);
        expect(serialized['d'], isNull);
        expect(serialized['m'], isNull);
        expect(serialized['s'], isNull);
        expect(serialized['rawi'], isNull);
      });

      test('should handle complex multi-filter query for API endpoint', () {
        final params = HadithSearchParams(
          value: 'الصلاة',
          page: 2,
          exclude: 'السنة',
          searchMethod: SearchMethod.allWords,
          zone: SearchZone.qudsi,
          degrees: [HadithDegree.authenticHadith],
          mohdith: [MohdithReference.bukhari],
          books: [BookReference.sahihBukhari],
          rawi: [RawiReference.abuHurayrah],
        );

        final serialized = QuerySerializer.serializeHadithParams(
          params,
          isApiEndpoint: true,
        );

        // Verify all parameters use correct keys
        expect(serialized['skey'], equals('الصلاة'), reason: 'Search text');
        expect(serialized['page'], equals(2), reason: 'Page number');
        expect(serialized['xclude'], equals('السنة'), reason: 'Exclude');
        expect(
          serialized['st'],
          equals(SearchMethod.allWords.id),
          reason: 'Search method',
        );
        expect(serialized['t'], equals(SearchZone.qudsi.id), reason: 'Zone');
        expect(
          serialized['d'],
          equals([HadithDegree.authenticHadith.id]),
          reason: 'Degrees',
        );
        expect(
          serialized['m'],
          equals([MohdithReference.bukhari.id]),
          reason: 'Mohdith',
        );
        expect(
          serialized['s'],
          equals([BookReference.sahihBukhari.id]),
          reason: 'Books',
        );
        expect(
          serialized['rawi'],
          equals([RawiReference.abuHurayrah.id]),
          reason: 'Rawi',
        );

        // Verify wrong keys are NOT present
        expect(serialized['q'], isNull, reason: 'Should use skey, not q');
        expect(serialized['grp'], isNull, reason: 'Should use t, not grp');
        expect(serialized['rad'], isNull, reason: 'Should use d, not rad');
        expect(serialized['tr'], isNull, reason: 'Should use m, not tr');
        expect(serialized['mhd'], isNull, reason: 'Should use s, not mhd');
      });
    });

    group('toQueryString()', () {
      test('should serialize simple key-value pairs', () {
        final params = {'q': 'test', 'page': 1};
        final queryString = QuerySerializer.toQueryString(params);

        expect(queryString, contains('q=test'));
        expect(queryString, contains('page=1'));
        expect(queryString, contains('&'));
      });

      test('should handle array parameters with [] suffix', () {
        final params = {
          'q': 'test',
          'd': ['1', '2'],
        };
        final queryString = QuerySerializer.toQueryString(params);

        expect(queryString, contains('q=test'));
        expect(queryString, contains('d[]=1'));
        expect(queryString, contains('d[]=2'));
      });

      test('should URL encode special characters', () {
        final params = {'q': 'الصلاة والسلام'};
        final queryString = QuerySerializer.toQueryString(params);

        // Should be URL encoded
        expect(queryString, contains('q='));
        expect(queryString, isNot(contains(' ')));
        expect(queryString, contains('%'));
      });

      test('should skip null values', () {
        final params = {'q': 'test', 'page': null};
        final queryString = QuerySerializer.toQueryString(params);

        expect(queryString, contains('q=test'));
        expect(queryString, isNot(contains('page')));
      });

      test('should handle empty params', () {
        final params = <String, dynamic>{};
        final queryString = QuerySerializer.toQueryString(params);

        expect(queryString, isEmpty);
      });

      test('should handle multiple array parameters', () {
        final params = {
          's': ['6216', '6214'],
          'm': ['6'],
          'd': ['1'],
        };
        final queryString = QuerySerializer.toQueryString(params);

        expect(queryString, contains('s[]=6216'));
        expect(queryString, contains('s[]=6214'));
        expect(queryString, contains('m[]=6'));
        expect(queryString, contains('d[]=1'));
      });
    });

    group('buildUrl()', () {
      test('should build URL without query params', () {
        final url = QuerySerializer.buildUrl(
          'https://dorar.net/hadith/search',
          {},
        );

        expect(url, equals('https://dorar.net/hadith/search'));
      });

      test('should build URL with query params', () {
        final url = QuerySerializer.buildUrl(
          'https://dorar.net/hadith/search',
          {'q': 'test', 'page': 1},
        );

        expect(url, startsWith('https://dorar.net/hadith/search?'));
        expect(url, contains('q=test'));
        expect(url, contains('page=1'));
      });

      test('should handle complex URL with filters', () {
        final url = QuerySerializer.buildUrl(
          'https://dorar.net/dorar_api.json',
          {
            'skey': 'الصلاة',
            'page': 1,
            'd': ['1'],
            's': ['6216'],
          },
        );

        expect(url, startsWith('https://dorar.net/dorar_api.json?'));
        expect(url, contains('skey='));
        expect(url, contains('page=1'));
        expect(url, contains('d[]=1'));
        expect(url, contains('s[]=6216'));
      });
    });
  });
}
