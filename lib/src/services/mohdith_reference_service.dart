import 'dart:convert';

import '../models/mohdith_item.dart';
import '../utils/arabic_search.dart';
import '../utils/asset_loader/asset_loader.dart';

/// Service for browsing and searching Hadith scholars (Muhaddithin).
///
/// Loads scholar data from JSON asset file.
/// For detailed scholar information, use `MohdithService`.
class MohdithReferenceService {
  /// Asset loader for reading JSON files.
  final AssetLoader _assetLoader;

  /// Path to the mohdith.json file.
  final String _assetPath;

  /// In-memory cache of all scholars (key = ID).
  Map<String, MohdithItem>? _cache;

  /// Create a new service instance.
  ///
  /// [assetLoader] defaults to the platform-specific loader if not provided.
  /// [assetPath] defaults to 'assets/data/mohdith.json'.
  MohdithReferenceService({
    AssetLoader? assetLoader,
    String assetPath = 'assets/data/mohdith.json',
  }) : _assetLoader = assetLoader ?? createAssetLoader(),
       _assetPath = assetPath;

  /// Count scholars. If [query] provided, counts only matching scholars.
  Future<int> countMohdith({String? query}) async {
    await initialize();

    if (query == null || query.isEmpty) {
      return _cache!.length;
    }

    return _cache!.values
        .where((mohdith) => fuzzyMatch(mohdith.name, query))
        .length;
  }

  /// Get all scholars with pagination support.
  ///
  /// - [limit]: Maximum results to return (default: 20)
  /// - [offset]: Number of results to skip (default: 0)
  Future<List<MohdithItem>> getAllMohdith({
    int limit = 20,
    int offset = 0,
  }) async {
    await initialize();

    return _cache!.values.skip(offset).take(limit).toList();
  }

  /// Get a scholar by ID. Returns null if not found.
  Future<MohdithItem?> getMohdithById(String id) async {
    await initialize();
    return _cache![id];
  }

  /// Get scholars by a list of IDs.
  ///
  /// Returns only the scholars that exist (skips invalid IDs).
  ///
  /// Example:
  /// ```dart
  /// final scholars = await service.getMohdithByIds(['256', '261', '204']);
  /// // Returns: [Al-Bukhari, Muslim, Al-Shafi'i]
  /// ```
  Future<List<MohdithItem>> getMohdithByIds(List<String> ids) async {
    await initialize();

    final results = <MohdithItem>[];
    for (final id in ids) {
      final mohdith = _cache![id];
      if (mohdith != null) {
        results.add(mohdith);
      }
    }
    return results;
  }

  /// Load scholar data from JSON and build the in-memory cache.
  /// Safe to call multiple times (subsequent calls do nothing).
  Future<void> initialize() async {
    // Skip if already initialized
    if (_cache != null) return;

    // Load JSON content
    final jsonString = await _assetLoader.loadString(_assetPath);
    final List<dynamic> jsonList = json.decode(jsonString);

    // Parse and build cache
    _cache = {};
    for (final item in jsonList) {
      final mohdith = MohdithItem.fromJson(item as Map<String, dynamic>);
      _cache![mohdith.id] = mohdith;
    }
  }

  /// Search scholars by name using fuzzy Arabic matching.
  ///
  /// The [query] is normalized before matching (diacritics removed).
  /// Returns paginated results.
  Future<List<MohdithItem>> searchMohdith(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    await initialize();

    if (query.isEmpty) {
      return getAllMohdith(limit: limit, offset: offset);
    }

    // Filter using fuzzy matching
    final matches = _cache!.values
        .where((mohdith) => fuzzyMatch(mohdith.name, query))
        .skip(offset)
        .take(limit)
        .toList();

    return matches;
  }
}
