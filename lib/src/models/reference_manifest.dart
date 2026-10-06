import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Bundled provenance and integrity contract, independent of online availability.
class ReferenceManifest {
  ReferenceManifest._(
    this.snapshotVersion,
    this.schemaVersion,
    this.normalizationVersion,
    this.collections,
  );
  final String snapshotVersion;
  final int schemaVersion;
  final int normalizationVersion;
  final Map<String, dynamic> collections;
  factory ReferenceManifest.fromJson(Map<String, dynamic> json) {
    final version = json['snapshotVersion'];
    final schema = json['schemaVersion'];
    final normalization = json['normalizationVersion'];
    final collections = json['collections'];
    if (version is! String ||
        !RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(version) ||
        schema != 2 ||
        normalization != 1 ||
        collections is! Map<String, dynamic>) {
      throw const FormatException('Incompatible reference manifest');
    }
    for (final name in ['book', 'mohdith', 'rawi']) {
      final item = collections[name];
      if (item is! Map ||
          item['sha256'] is! String ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch(item['sha256'] as String) ||
          item['count'] is! int ||
          (item['count'] as int) < 1 ||
          item['coverage'] is! String) {
        throw FormatException('Invalid $name reference manifest entry');
      }
    }
    return ReferenceManifest._(
      version,
      schema as int,
      normalization as int,
      Map.unmodifiable(collections),
    );
  }
  factory ReferenceManifest.decode(String value) =>
      ReferenceManifest.fromJson(jsonDecode(value) as Map<String, dynamic>);
  String get rawiHash => (collections['rawi'] as Map)['sha256'] as String;
  int get rawiCount => (collections['rawi'] as Map)['count'] as int;
  String get databaseFileName =>
      'rawi-$snapshotVersion-v$schemaVersion-$rawiHash.db';
  void validateBytes(String collection, Uint8List bytes) {
    if (sha256.convert(bytes).toString() !=
        (collections[collection] as Map)['sha256']) {
      throw FormatException('$collection reference integrity mismatch');
    }
  }
}
