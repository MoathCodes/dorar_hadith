/// Represents information about a Mohdith (hadith scholar).
class MohdithInfo {
  /// Name of the scholar
  final String name;

  /// Unique identifier
  final String mohdithId;

  /// Biographical information about the scholar
  final String info;

  const MohdithInfo({
    required this.name,
    required this.mohdithId,
    required this.info,
  });

  factory MohdithInfo.fromJson(Map<String, dynamic> json) {
    return MohdithInfo(
      name: json['name'] as String,
      mohdithId: json['mohdithId'] as String,
      info: json['info'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'mohdithId': mohdithId, 'info': info};
  }

  @override
  String toString() {
    return 'MohdithInfo(mohdithId: $mohdithId, name: $name, '
        'info: ${info.length > 50 ? '${info.substring(0, 50)}...' : info})';
  }
}
