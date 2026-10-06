/// Dorar Hadith — a pure Dart library for the Dorar.net Hadith API.
///
/// Works in CLI scripts, servers, and tests without Flutter. Provides a
/// type-safe interface for searching and retrieving hadiths from Dorar.net.
///
/// ## Features
///
/// - Hadith search with filters
/// - [DetailedHadith] site records alongside lightweight quick-API [Hadith]
///   results
/// - Sharh (explanations)
/// - Offline reference data (books, scholars, narrators)
/// - Built-in persistent caching
///
/// ## Flutter apps
///
/// Use the companion package
/// [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter) —
/// do **not** wire `rootBundle`, `AssetLoader.configure`, or database copy
/// logic yourself. Call `DorarHadithFlutter.ensureInitialized()` once in
/// `main()` before offline reference or narrator APIs. Core Flutter setup
/// helpers were removed in 0.5.0.
///
/// ## Usage
///
/// ```dart
/// import 'package:dorar_hadith/dorar_hadith.dart';
///
/// void main() async {
///   await DorarClient.use((client) async {
///     // Search hadiths
///     final results = await client.searchHadith(
///       HadithSearchParams(value: 'الصلاة', page: 1),
///     );
///
///     // Only hadiths with takhrij metadata (Dorar UI label: متخصص)
///     final filtered = await client.searchHadithDetailed(
///       HadithSearchParams(
///         value: 'النية',
///         specialist: true,
///         degrees: [HadithDegree.authenticHadith],
///       ),
///     );
///
///     // Browse books (offline on CLI; Flutter needs dorar_hadith_flutter)
///     final books = await client.searchBooks('صحيح');
///
///     // Get detailed book info (online)
///     final bookInfo = await client.book.getById(books.first.id);
///   });
/// }
/// ```
///
/// See [README.md](https://github.com/MoathCodes/dorar_hadith) for platform
/// behavior, offline failure modes, and error handling.
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
// Database (Drift) - Exported for advanced usage
export 'src/database/cache_database.dart';
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
export 'src/models/hadith_category.dart';
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

export 'src/models/identifiers.dart';
export 'src/models/source_content.dart';
export 'src/models/result_details.dart';
export 'src/parsers/document_parser.dart'
    show DocumentParser, renderDocumentHtml;
export 'src/constants/hadith_type_filter.dart';
export 'src/models/related_content.dart';
export 'src/models/discovery.dart';
export 'src/services/category_service.dart';
export 'src/services/reference_discovery_service.dart';

export 'src/database/reference_migration.dart';
export 'src/models/reference_manifest.dart';
export 'src/models/render_token.dart';
export 'src/constants/search_capabilities.dart';
