/// Source search scopes, not mutually exclusive speaker classifications.
enum HadithTypeFilter {
  marfoo('0'),
  qudsi('1'),
  companionAthar('2'),
  withExplanation('4');

  const HadithTypeFilter(this.id);
  final String id;
}

enum HadithSort { degree }
