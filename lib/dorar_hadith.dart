/// Dorar Hadith - A Dart package for interacting with the Dorar.net Hadith API
///
/// Provides a type-safe interface for searching and retrieving hadiths
/// from the Dorar.net API.
///
/// ## Features
///
/// - Hadith search with filters
/// - Unified `DetailedHadith` model that extends the lightweight `Hadith`
///   listing results
/// - Sharh (explanations)
/// - Offline reference data (books, scholars, narrators)
/// - Built-in caching
///
/// ## Usage
///
/// ```dart
/// import 'package:dorar_hadith/dorar_hadith.dart';
///
/// void main() async {
///   final client = DorarClient();
///
///   // Search hadiths
///   final results = await client.searchHadith(
///     HadithSearchParams(value: 'الصلاة', page: 1),
///   );
///
///   // Search with filters
///   final filtered = await client.searchHadithDetailed(
///     HadithSearchParams(
///       value: 'النية',
///       specialist: true,
///       degrees: [HadithDegree.authenticHadith],
///     ),
///   );
///
///   // Browse books (offline)
///   final books = await client.searchBooks('صحيح');
///
///   // Get detailed book info
///   final bookInfo = await client.book.getById(books.first.id);
///
///   await client.dispose();
/// }
/// ```
library;

// Client - Main entry point
export 'src/client/dorar_client.dart';
// Constants & Enums
export 'src/constants/book_reference.dart';
export 'src/constants/hadith_degree.dart';
export 'src/constants/mohdith_reference.dart';
export 'src/constants/rawi_reference.dart';
export 'src/constants/search_method.dart';
export 'src/constants/search_zone.dart';
export 'src/database/connection/connection_flutter.dart';
// Database (Drift) - Exported for advanced usage
export 'src/database/rawi_database.dart';
// HTTP & Networking
export 'src/http/endpoints.dart';
export 'src/http/http_client.dart';
export 'src/http/query_serializer.dart';
// Models - API Models (detailed data)
export 'src/models/api_response.dart';
export 'src/models/book.dart';
// Models - Reference Models (lightweight browsing)
export 'src/models/book_item.dart';
export 'src/models/hadith.dart';
export 'src/models/mohdith.dart';
export 'src/models/mohdith_item.dart';
export 'src/models/rawi_item.dart';
export 'src/models/reference_item.dart';
export 'src/models/search_metadata.dart';
export 'src/models/search_params.dart';
export 'src/models/sharh.dart';
export 'src/models/sharh_metadata.dart';
export 'src/models/usul_hadith.dart';
// Services - Reference Services (lightweight browsing from assets)
export 'src/services/book_reference_service.dart';
// Services - API Services (detailed data from dorar.net)
export 'src/services/book_service.dart';
export 'src/services/hadith_service.dart';
export 'src/services/mohdith_reference_service.dart';
export 'src/services/mohdith_service.dart';
export 'src/services/rawi_reference_service.dart';
export 'src/services/sharh_service.dart';
// Utilities
export 'src/utils/arabic_search.dart';
export 'src/utils/asset_loader/asset_loader.dart';
export 'src/utils/exceptions.dart';
export 'src/utils/html_stripper.dart';
export 'src/utils/validators.dart';
