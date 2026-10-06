// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dorar_hadith/src/http/http_client.dart';
import 'package:http/http.dart' as http;

/// Explicit, resumable source capture. Never runs during normal tests/startup.
Future<void> main(List<String> args) async {
  final targets = (jsonDecode(
    await File('tool/upstream_contract_targets.json').readAsString(),
  ) as Map<String, dynamic>).cast<String, String>();
  final names = args.where((a) => !a.startsWith('--')).toList();
  final selected = names.isEmpty ? targets.keys : names;
  final client = http.Client();
  final output = Directory('test/fixtures/upstream');
  await output.create(recursive: true);
  try {
    for (final name in selected) {
      final url = targets[name];
      if (url == null) throw ArgumentError('Unknown capture: $name');
      final file = File('${output.path}/$name.json');
      if (await file.exists() && !args.contains('--force')) continue;
      final response = await client
          .get(
            Uri.parse(url),
            headers: {
              ...DorarHttpClient.defaultHeaders,
              if (name.endsWith('_ajax')) 'X-Requested-With': 'XMLHttpRequest',
            },
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
      }
      final body = utf8.decode(response.bodyBytes);
      if (await file.exists()) {
        final previousBytes = await file.readAsBytes();
        final hash = sha256.convert(previousBytes).toString();
        final archived = File(
          'test/fixtures/upstream_history/$name-$hash.json',
        );
        await archived.parent.create(recursive: true);
        if (!await archived.exists()) {
          await archived.writeAsBytes(previousBytes, flush: true);
        }
      }
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert({
          'url': url,
          'capturedAt': DateTime.now().toUtc().toIso8601String(),
          'statusCode': response.statusCode,
          'contentType': response.headers['content-type'],
          'sha256': sha256.convert(utf8.encode(body)).toString(),
          'body': body,
        }),
      );
      print('Captured $name (${response.bodyBytes.length} bytes)');
    }
  } finally {
    client.close();
  }
  final captures = <Map<String, dynamic>>[];
  for (final name in targets.keys.toList()..sort()) {
    final file = File('${output.path}/$name.json');
    if (!await file.exists()) continue;
    final bytes = await file.readAsBytes();
    final capture = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    if (capture['url'] != targets[name] ||
        capture['sha256'] !=
            sha256.convert(utf8.encode(capture['body'] as String)).toString()) {
      throw FormatException('Invalid captured contract: $name');
    }
    captures.add({
      'name': name,
      ...capture..remove('body'),
      'captureFileSha256': sha256.convert(bytes).toString(),
    });
  }
  await File('test/fixtures/upstream_manifest.json').writeAsString(
    '${const JsonEncoder.withIndent('  ').convert({'schemaVersion': 1, 'method': 'Explicit direct Dorar capture; body hashes are UTF-8 decoded response hashes', 'captureCount': captures.length, 'captures': captures})}\n',
  );
}
