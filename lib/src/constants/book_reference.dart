/// Reference class for Islamic books containing hadiths.
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
  static const sunanAbuDawud = BookReference(id: '4549', name: 'سنن أبي داود');

  /// Jami' Al-Tirmidhi
  static const jamiTirmidhi = BookReference(id: '3662', name: 'سنن الترمذي');

  /// Sunan Al-Nasa'i
  static const sunanNasai = BookReference(id: '5766', name: 'سنن النسائي');

  /// Sunan Ibn Majah
  static const sunanIbnMajah = BookReference(id: '5299', name: 'سنن ابن ماجه');

  /// Musnad Ahmad
  static const musnadAhmad = BookReference(id: '14', name: 'مسند أحمد');

  /// Muwatta Malik
  static const muwattaMalik = BookReference(id: '6453', name: 'موطأ مالك');

  /// Musnad Al-Darimi
  static const musnadDarimi = BookReference(id: '6277', name: 'سنن الدارمي');

  /// Sahih Ibn Khuzaymah
  static const sahihIbnKhuzaymah = BookReference(
    id: '3024',
    name: 'صحيح ابن خزيمة',
  );

  /// Sahih Ibn Hibban
  static const sahihIbnHibban = BookReference(
    id: '5876',
    name: 'صحيح ابن حبان',
  );

  /// Al-Mustadrak ala Al-Sahihayn (Al-Hakim)
  static const mustadrakHakim = BookReference(
    id: '2800',
    name: 'المستدرك على الصحيحين',
  );

  /// Sunan Al-Bayhaqi Al-Kubra
  static const sunanBayhaqiKubra = BookReference(
    id: '7989',
    name: 'السنن الكبرى للبيهقي',
  );

  /// Sunan Al-Daraqutni
  static const sunanDaraqutni = BookReference(
    id: '3233',
    name: 'سنن الدارقطني',
  );

  /// Musannaf Ibn Abi Shaybah
  static const musannafIbnAbiShaybah = BookReference(
    id: '6598',
    name: 'مصنف ابن أبي شيبة',
  );

  /// Musannaf Abd al-Razzaq
  static const musannafAbdRazzaq = BookReference(
    id: '7613',
    name: 'مصنف عبد الرزاق',
  );

  /// Riyad Al-Salihin
  static const riyadSalihin = BookReference(id: '10106', name: 'رياض الصالحين');

  /// Bulugh Al-Maram
  static const bulughMaram = BookReference(id: '9927', name: 'بلوغ المرام');

  /// List of most commonly used books
  static const List<BookReference> popularBooks = [
    all,
    sahihBukhari,
    sahihMuslim,
    sunanAbuDawud,
    jamiTirmidhi,
    sunanNasai,
    sunanIbnMajah,
    musnadAhmad,
    muwattaMalik,
    arbainNawawi,
    riyadSalihin,
    bulughMaram,
    sahihMusnad,
    musnadDarimi,
    sahihIbnKhuzaymah,
    sahihIbnHibban,
    mustadrakHakim,
    sunanBayhaqiKubra,
    sunanDaraqutni,
    musannafIbnAbiShaybah,
    musannafAbdRazzaq,
  ];

  /// Unique identifier for the book
  final String id;

  /// Arabic name of the book
  final String name;

  const BookReference({required this.id, required this.name});

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

  /// Find a book by ID from the popular list
  static BookReference? findPopularById(String id) {
    try {
      return popularBooks.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
