/// Reference class for Rawi (hadith narrators/transmitters).
/// Due to the large number of narrators (~14,000), only few
/// of the companions are provided as constants.
class RawiReference {
  /// All narrators (no filter)
  static const all = RawiReference(id: '0', name: 'الجميع');

  /// Abu Hurayrah (most prolific narrator)
  static const abuHurayrah = RawiReference(id: '1416', name: 'أبو هريرة');

  /// Aisha bint Abi Bakr (Mother of the Believers)
  static const aisha = RawiReference(id: '6617', name: 'عائشة أم المؤمنين');

  // ========== Popular Companions (Constants) ==========

  /// Abdullah ibn Abbas
  static const ibnAbbas = RawiReference(id: '2664', name: 'ابن عباس');

  /// Abdullah ibn Umar
  static const ibnUmar = RawiReference(id: '7687', name: 'عبدالله بن عمر');

  /// Anas ibn Malik
  static const anasBinMalik = RawiReference(id: '2177', name: 'أن س بن مالك');

  /// Jabir ibn Abdullah
  static const jabirIbnAbdullah = RawiReference(
    id: '3971',
    name: 'جابر بن عبدالله',
  );

  /// Abu Sa'id Al-Khudri
  static const abuSaidKhudri = RawiReference(
    id: '779',
    name: 'أبو سعيد الخدري',
  );

  /// Abdullah ibn Mas'ud
  static const ibnMasud = RawiReference(id: '7918', name: 'عبدالله بن مسعود');

  /// Abu Musa Al-Ash'ari
  static const abuMusaAshari = RawiReference(
    id: '1342',
    name: 'أبو موسى الأشعري',
  );

  /// Umar ibn Al-Khattab
  static const umarIbnKhattab = RawiReference(
    id: '8918',
    name: 'عمر بن الخطاب',
  );

  /// Ali ibn Abi Talib
  static const aliIbnAbiTalib = RawiReference(
    id: '8637',
    name: 'علي بن أبي طالب',
  );

  /// Abu Bakr Al-Siddiq
  static const abuBakr = RawiReference(id: '455', name: 'أبو بكر الصديق');

  /// Uthman ibn Affan
  static const uthmanIbnAffan = RawiReference(
    id: '8310',
    name: 'عثمان بن عفان',
  );

  /// Salman Al-Farisi
  static const salmanFarisi = RawiReference(id: '5947', name: 'سلمان الفارسي');

  /// Mu'adh ibn Jabal
  static const muadhIbnJabal = RawiReference(id: '10349', name: 'معاذ بن جبل');

  /// Abu Dharr Al-Ghifari
  static const abuDharr = RawiReference(id: '667', name: 'أبو ذر الغفاري');

  /// Bilal ibn Rabah
  static const bilal = RawiReference(id: '3808', name: 'بلال بن رباح');

  /// Zayd ibn Thabit
  static const zaydIbnThabit = RawiReference(id: '5545', name: 'زيد بن ثابت');

  /// Ubayy ibn Ka'b
  static const ubayyIbnKab = RawiReference(id: '1695', name: 'أبي بن كعب');

  /// Abu Ayyub Al-Ansari
  static const abuAyyub = RawiReference(id: '129', name: 'أبو أيوب الأنصاري');

  /// Unique identifier for the narrator
  final String id;

  /// Arabic name of the narrator
  final String name;

  const RawiReference({required this.id, required this.name});

  factory RawiReference.fromJson(Map<String, dynamic> json) {
    return RawiReference(
      id: json['key'] as String,
      name: json['value'] as String,
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawiReference &&
          runtimeType == other.runtimeType &&
          id == other.id;

  Map<String, dynamic> toJson() {
    return {'key': id, 'value': name};
  }

  @override
  String toString() => name;
}
