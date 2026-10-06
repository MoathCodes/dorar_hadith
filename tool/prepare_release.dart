import 'dart:io';

/// Prepare reviewable, isolated package directories; never publishes or commits.
Future<void> main(List<String> args) async {
  if (args.length != 1) {
    throw ArgumentError(
      'Usage: dart run tool/prepare_release.dart OUTPUT_DIRECTORY',
    );
  }
  final output = Directory(args.single);
  if (await output.exists()) {
    throw ArgumentError('Output directory already exists');
  }
  await output.create(recursive: true);
  Future<void> copy(String source, String destination) async {
    final kind = FileSystemEntity.typeSync(source, followLinks: false);
    if (kind == FileSystemEntityType.directory) {
      await Directory(destination).create(recursive: true);
      for (final entry in Directory(source).listSync()) {
        final name = entry.uri.pathSegments.where((s) => s.isNotEmpty).last;
        if ([
              'build',
              '.dart_tool',
              'ephemeral',
              'pubspec.lock',
              'pubspec_overrides.yaml',
              '.flutter-plugins-dependencies',
              '.metadata',
            ].contains(name) ||
            name.endsWith('.wasm') ||
            name.endsWith('.js') ||
            name.endsWith('.js.map') ||
            name.endsWith('.js.deps')) {
          continue;
        }
        await copy(entry.path, '$destination/$name');
      }
    } else if (kind == FileSystemEntityType.file) {
      await File(destination).parent.create(recursive: true);
      await File(source).copy(destination);
    } else if (kind == FileSystemEntityType.link) {
      throw FileSystemException(
        'Release staging refuses symbolic links',
        source,
      );
    }
  }

  for (final package in ['dorar_hadith', 'dorar_hadith_flutter']) {
    final base = package == 'dorar_hadith' ? '.' : 'dorar_hadith_flutter';
    final destination = '${output.path}/$package';
    await Directory(destination).create();
    for (final entry in [
      'lib',
      'assets',
      'example',
      'doc',
      'README.md',
      'README_AR.md',
      'CHANGELOG.md',
      'LICENSE',
      'pubspec.yaml',
      'analysis_options.yaml',
      'build.yaml',
      '.pubignore',
    ]) {
      final source = '$base/$entry';
      if (FileSystemEntity.typeSync(source) != FileSystemEntityType.notFound) {
        await copy(source, '$destination/$entry');
      }
    }
  }
  stdout.writeln('Prepared package source directories: ${output.path}');
  stdout.writeln(
    'No publication performed. Run the documented candidate and stable gates before uploading.',
  );
}
