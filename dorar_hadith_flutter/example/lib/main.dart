import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? error;
  try {
    await DorarHadithFlutter.ensureInitialized();
  } catch (e) {
    error = e;
  }
  runApp(DorarExample(initializationError: error));
}

class DorarExample extends StatelessWidget {
  const DorarExample({super.key, this.initializationError});
  final Object? initializationError;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Dorar package example',
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: initializationError == null
        ? const ReferenceScreen()
        : Scaffold(
            body: Center(
              child: Text('Initialization failed: $initializationError'),
            ),
          ),
  );
}

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});
  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  final _client = DorarClient();
  final _query = TextEditingController(text: 'أبو هريرة');
  late Future<List<RawiItem>> _narrators;
  Sharh? _explanation;
  String? _error;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _narrators = _client.searchRawi(_query.text);
  }

  @override
  void dispose() {
    _query.dispose();
    _client.dispose();
    super.dispose();
  }

  Future<void> _loadExplanation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _client.sharh.getById('137940');
      if (mounted) setState(() => _explanation = result);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dorar package example')),
    body: Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('بحث الرواة في المرجع المحلي'),
          TextField(
            controller: _query,
            onSubmitted: (_) =>
                setState(() => _narrators = _client.searchRawi(_query.text)),
          ),
          FilledButton(
            onPressed: () =>
                setState(() => _narrators = _client.searchRawi(_query.text)),
            child: const Text('بحث محلي'),
          ),
          FutureBuilder<List<RawiItem>>(
            future: _narrators,
            builder: (context, state) {
              if (state.hasError) {
                return Text('Reference lookup failed: ${state.error}');
              }
              if (!state.hasData) return const LinearProgressIndicator();
              return Column(
                children: [
                  for (final item in state.data!)
                    ListTile(title: Text(item.name), subtitle: Text(item.id)),
                ],
              );
            },
          ),
          const Divider(),
          FilledButton(
            onPressed: _loading ? null : _loadExplanation,
            child: const Text('تحميل شرح من الدرر السنية'),
          ),
          if (_loading) const LinearProgressIndicator(),
          if (_error != null) Text(_error!),
          if (_explanation != null) ...[
            Text('${_explanation!.book} — ${_explanation!.grade}'),
            const SizedBox(height: 12),
            // Structural kinds style the content; no speaker colors are inferred.
            for (final block in _explanation!.document!.blocks)
              block.kind == BlockKind.separator
                  ? const Divider()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style
                              .copyWith(height: 1.8),
                          children: [
                            for (final token
                                in documentRenderTokens(_explanation!.document!)
                                    .where(
                                      (t) =>
                                          t.range.start >= block.range.start &&
                                          t.range.end <= block.range.end,
                                    ))
                              TextSpan(
                                text: token.text,
                                style: TextStyle(
                                  fontWeight: block.kind == BlockKind.heading
                                      ? FontWeight.bold
                                      : null,
                                  decoration:
                                      token.annotations.any(
                                        (a) =>
                                            a.kind == AnnotationKind.glossary,
                                      )
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
          ],
        ],
      ),
    ),
  );
}
