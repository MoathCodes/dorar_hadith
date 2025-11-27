import 'package:freezed_annotation/freezed_annotation.dart';

part 'mohdith.freezed.dart';
part 'mohdith.g.dart';

/// Represents information about a Mohdith (hadith scholar).
@freezed
abstract class MohdithInfo with _$MohdithInfo {
  const factory MohdithInfo({
    /// Name of the scholar
    required String name,

    /// Unique identifier
    required String mohdithId,

    /// Biographical information about the scholar
    required String info,
  }) = _MohdithInfo;

  factory MohdithInfo.fromJson(Map<String, dynamic> json) =>
      _$MohdithInfoFromJson(json);
}
