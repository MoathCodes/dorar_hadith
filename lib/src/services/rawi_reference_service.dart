import '../database/rawi_database.dart';
import '../models/rawi_item.dart';

/// Service for browsing and searching narrators (Ruwat).
///
/// Uses SQLite database (via Drift) with 11,436 narrators.
class RawiReferenceService {
  /// The underlying Drift database instance.
  final RawiDatabase _database;

  /// Create a new service instance.
  ///
  /// If [database] is not provided, a new instance will be created.
  RawiReferenceService({RawiDatabase? database})
    : _database = database ?? RawiDatabase();

  /// Count all narrators. If [query] provided, counts only matching narrators.
  Future<int> countRawi({String? query}) async {
    return await _database.countRawi(query: query);
  }

  /// Close the database connection. Call when done using the service.
  Future<void> dispose() async {
    await _database.dispose();
  }

  /// Get all narrators with pagination support.
  ///
  /// - [limit]: Maximum results to return (default: 50)
  /// - [offset]: Number of results to skip (default: 0)
  Future<List<RawiItem>> getAllRawi({int limit = 50, int offset = 0}) async {
    return await _database.getAllRawi(limit: limit, offset: offset);
  }

  /// Get a narrator by ID. Returns null if not found.
  Future<RawiItem?> getRawiById(int id) async {
    return await _database.getRawiById(id);
  }

  /// Get narrators by a list of IDs. Skips invalid IDs.
  Future<List<RawiItem>> getRawiByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    return await _database.getRawiByKeys(ids);
  }

  /// Search narrators by name using database LIKE query.
  ///
  /// Search is performed on normalized Arabic text (diacritics already removed).
  /// Returns paginated results.
  Future<List<RawiItem>> searchRawi(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    return await _database.searchRawi(query, limit: limit, offset: offset);
  }
}
