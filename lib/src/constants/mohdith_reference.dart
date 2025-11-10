/// Reference class for Mohdith (hadith scholars/narrators).
/// Represents a specific scholar with their ID and name.
class MohdithReference {
  /// All scholars (no filter)
  static const all = MohdithReference(id: '0', name: 'الجميع');

  /// Imam Malik ibn Anas
  static const malik = MohdithReference(id: '179', name: 'الإمام مالك');

  /// Imam Al-Shafi'i
  static const shafii = MohdithReference(id: '204', name: 'الإمام الشافعي');

  // ========== Popular Scholars (Constants) ==========

  /// Imam Ahmad ibn Hanbal
  static const ahmad = MohdithReference(id: '241', name: 'الإمام أحمد');

  /// Imam Al-Bukhari
  static const bukhari = MohdithReference(id: '256', name: 'البخاري');

  /// Imam Muslim
  static const muslim = MohdithReference(id: '261', name: 'مسلم');

  /// Imam Ibn Majah
  static const ibnMajah = MohdithReference(id: '273', name: 'ابن ماجه');

  /// Imam Abu Dawud
  static const abuDawud = MohdithReference(id: '275', name: 'أبو داود');

  /// Imam Al-Tirmidhi
  static const tirmidhi = MohdithReference(id: '279', name: 'الترمذي');

  /// Imam Al-Nasa'i
  static const nasai = MohdithReference(id: '303', name: 'النسائي');

  /// Sufyan Al-Thawri
  static const sufyanThawri = MohdithReference(id: '161', name: 'سفيان الثوري');

  /// Abdullah ibn al-Mubarak
  static const ibnMubarak = MohdithReference(
    id: '181',
    name: 'عبدالله بن المبارك',
  );

  /// Sufyan ibn Uyaynah
  static const sufyanIbnUyaynah = MohdithReference(
    id: '198',
    name: 'سفيان بن عيينة',
  );

  /// Ishaq ibn Rahawayh
  static const ishaqIbnRahawayh = MohdithReference(
    id: '238',
    name: 'إسحاق بن راهويه',
  );

  /// Al-Darimi
  static const darimi = MohdithReference(id: '250', name: 'الدارمي');

  /// Ibn Khuzaymah
  static const ibnKhuzaymah = MohdithReference(id: '311', name: 'ابن خزيمة');

  /// Ibn Hibban
  static const ibnHibban = MohdithReference(id: '354', name: 'ابن حبان');

  /// Al-Hakim al-Naysaburi
  static const hakim = MohdithReference(id: '405', name: 'الحاكم');

  /// Al-Bayhaqi
  static const bayhaqi = MohdithReference(id: '458', name: 'البيهقي');

  /// Al-Tabarani
  static const tabarani = MohdithReference(id: '360', name: 'الطبراني');

  /// List of most commonly used scholars
  static const List<MohdithReference> popularScholars = [
    all,
    bukhari,
    muslim,
    abuDawud,
    tirmidhi,
    nasai,
    ibnMajah,
    ahmad,
    malik,
    shafii,
    darimi,
    ibnKhuzaymah,
    ibnHibban,
    hakim,
    bayhaqi,
    tabarani,
  ];

  /// Unique identifier for the scholar
  final String id;

  /// Arabic name of the scholar
  final String name;

  const MohdithReference({required this.id, required this.name});

  factory MohdithReference.fromJson(Map<String, dynamic> json) {
    return MohdithReference(
      id: json['key'] as String,
      name: json['value'] as String,
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MohdithReference &&
          runtimeType == other.runtimeType &&
          id == other.id;

  Map<String, dynamic> toJson() {
    return {'key': id, 'value': name};
  }

  @override
  String toString() => name;

  /// Find a scholar by ID from the popular list
  static MohdithReference? findPopularById(String id) {
    try {
      return popularScholars.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
