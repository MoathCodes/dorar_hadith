/// Reference class for Islamic books containing hadiths.
///
/// IDs and names must match [assets/data/book.json] (Dorar's book filter list).
/// For books not listed here, use [BookReferenceService.searchBook].
class BookReference {
  /// All books (no filter)
  static const all = BookReference(id: '0', name: 'الجميع');

  /// Sahih Al-Bukhari
  static const sahihBukhari = BookReference(id: '6216', name: 'صحيح البخاري');

  /// Sahih Muslim
  static const sahihMuslim = BookReference(id: '3088', name: 'صحيح مسلم');

  // ========== Popular Books (Constants) ==========

  /// Al-Arba'een Al-Nawawiyyah (40 Hadith of Nawawi)
  static const arbainNawawi = BookReference(
    id: '13457',
    name: 'الأربعون النووية',
  );

  /// Al-Sahih Al-Musnad
  static const sahihMusnad = BookReference(id: '96', name: 'الصحيح المسند');

  /// Sunan Abu Dawud
  static const sunanAbuDawud = BookReference(id: '6267', name: 'سنن أبي داود');

  /// Jami' Al-Tirmidhi
  static const jamiTirmidhi = BookReference(id: '13509', name: 'سنن الترمذي');

  /// Sunan Al-Nasa'i
  static const sunanNasai = BookReference(id: '13508', name: 'سنن النسائي');

  /// Sunan Ibn Majah (Dorar title spelling: ابن ماجة)
  static const sunanIbnMajah = BookReference(id: '6264', name: 'سنن ابن ماجة');

  /// Sahih Ibn Khuzaymah
  static const sahihIbnKhuzaymah = BookReference(
    id: '13558',
    name: 'صحيح ابن خزيمة',
  );

  /// Sahih Ibn Hibban
  static const sahihIbnHibban = BookReference(
    id: '16582',
    name: 'صحيح ابن حبان',
  );

  /// Al-Mustadrak ala Al-Sahihayn (Al-Hakim)
  static const mustadrakHakim = BookReference(
    id: '16226',
    name: 'المستدرك على الصحيحين',
  );

  /// Sunan Al-Bayhaqi Al-Kubra
  static const sunanBayhaqiKubra = BookReference(
    id: '13470',
    name: 'السنن الكبرى للبيهقي',
  );

  /// Sunan Al-Daraqutni
  static const sunanDaraqutni = BookReference(
    id: '13501',
    name: 'سنن الدارقطني',
  );

  /// Riyad Al-Salihin
  static const riyadSalihin = BookReference(id: '11155', name: 'رياض الصالحين');

  /// Bulugh Al-Maram
  static const bulughMaram = BookReference(id: '13553', name: 'بلوغ المرام');

  /// Unique identifier for the book
  final String id;

  /// Arabic name of the book
  final String name;

  const BookReference({required this.id, required this.name});

  /// All popular book shortcuts (excluding [all]).
  ///
  /// Used by tests to verify IDs against `book.json`.
  static const List<BookReference> knownBooks = [
    sahihBukhari,
    sahihMuslim,
    arbainNawawi,
    sahihMusnad,
    sunanAbuDawud,
    jamiTirmidhi,
    sunanNasai,
    sunanIbnMajah,
    sahihIbnKhuzaymah,
    sahihIbnHibban,
    mustadrakHakim,
    sunanBayhaqiKubra,
    sunanDaraqutni,
    riyadSalihin,
    bulughMaram,
  ];

  factory BookReference.fromJson(Map<String, dynamic> json) {
    return BookReference(
      id: json['key'] as String,
      name: json['value'] as String,
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookReference &&
          runtimeType == other.runtimeType &&
          id == other.id;

  Map<String, dynamic> toJson() {
    return {'key': id, 'value': name};
  }

  @override
  String toString() => name;
}
