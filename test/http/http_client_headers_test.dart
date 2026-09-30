import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group('DorarHttpClient default headers', () {
    test('sends Node-equivalent browser headers by default', () async {
      http.Request? captured;

      final mock = MockClient((request) async {
        captured = request;
        return http.Response('ok', 200);
      });

      final client = DorarHttpClient(client: mock, maxRetries: 1);
      await client.get('https://dorar.net/dorar_api.json?skey=test');
      client.dispose();

      expect(captured, isNotNull);
      expect(captured!.headers['user-agent'], contains('Mozilla/5.0'));
      expect(captured!.headers['accept-language'], 'ar,en;q=0.9');
      expect(captured!.headers['referer'], 'https://dorar.net/');
      expect(captured!.headers['origin'], 'https://dorar.net');
    });

    test('caller headers override defaults', () async {
      http.Request? captured;

      final mock = MockClient((request) async {
        captured = request;
        return http.Response('ok', 200);
      });

      final client = DorarHttpClient(client: mock, maxRetries: 1);
      await client.get(
        'https://dorar.net/dorar_api.json?skey=test',
        headers: {'User-Agent': 'custom-agent', 'X-Test': '1'},
      );
      client.dispose();

      expect(captured!.headers['user-agent'], 'custom-agent');
      expect(captured!.headers['x-test'], '1');
      expect(captured!.headers['referer'], 'https://dorar.net/');
    });

    test('mergeHeaders puts caller values last', () {
      final merged = DorarHttpClient.mergeHeaders({'User-Agent': 'override'});
      expect(merged['User-Agent'], 'override');
      expect(merged['Referer'], 'https://dorar.net/');
    });
  });
}
