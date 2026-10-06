import 'hadith_type_filter.dart';

/// Verified endpoint capabilities. Choosing a surface remains explicit.
class SearchCapabilities {
  const SearchCapabilities({
    required this.types,
    required this.narratorChoices,
    required this.multipleTypes,
    required this.optionalPhrases,
    required this.sort,
    required this.specialist,
    required this.pageSize,
    this.pageLimit,
  });
  final Set<HadithTypeFilter> types;
  final bool narratorChoices;
  final bool multipleTypes;
  final bool optionalPhrases;
  final bool sort;
  final bool specialist;
  final int pageSize;
  final int? pageLimit;
  static const quick = SearchCapabilities(
    types: {HadithTypeFilter.qudsi, HadithTypeFilter.companionAthar},
    narratorChoices: false,
    multipleTypes: false,
    optionalPhrases: false,
    sort: false,
    specialist: false,
    pageSize: 15,
  );
  static const detailed = SearchCapabilities(
    types: {
      HadithTypeFilter.marfoo,
      HadithTypeFilter.qudsi,
      HadithTypeFilter.companionAthar,
      HadithTypeFilter.withExplanation,
    },
    narratorChoices: true,
    multipleTypes: true,
    optionalPhrases: true,
    sort: true,
    specialist: true,
    pageSize: 30,
    pageLimit: 10,
  );
}
