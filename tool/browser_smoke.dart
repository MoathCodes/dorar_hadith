// Compile with `dart compile js tool/browser_smoke.dart -o browser_smoke.dart.js`.
// Serve alongside the example's assets, matching WASM and worker. A host HTML
// page supplies window.dorarSmokeComplete(String) to record the JSON report.
import 'dart:convert';
import 'dart:js_interop';

import 'package:dorar_hadith/dorar_hadith.dart';

@JS('window.dorarSmokeComplete')
external void _report(JSString result);

Future<void> main() async {
  final references = RawiReferenceService();
  final cache = CacheDatabase();
  try {
    const key = 'dorar-browser-smoke-only';
    final previous = await cache.getCacheEntry(key);
    final choices = await references.searchRawi('ابو هريره', limit: 1);
    await cache.insertOrUpdateCacheEntry(
      CacheTableCompanion.insert(
        key: key,
        body: 'browser cache survives reference snapshot changes',
        header: '',
        expiredAt: DateTime.now().add(const Duration(days: 1)),
      ),
    );
    _report(
      jsonEncode({
        'count': await references.countRawi(),
        'firstChoiceId': choices.first.id,
        'firstChoiceName': choices.first.name,
        'previousCacheBody': previous?.body,
        'writtenCacheBody': (await cache.getCacheEntry(key))!.body,
      }).toJS,
    );
  } catch (error) {
    _report(jsonEncode({'error': error.toString()}).toJS);
  } finally {
    await references.dispose();
    await cache.close();
  }
}
