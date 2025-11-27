import 'package:freezed_annotation/freezed_annotation.dart';

import 'reference_item.dart';

part 'mohdith_item.freezed.dart';
part 'mohdith_item.g.dart';

/// Lightweight model for scholar (mohdith) references.
///
/// For browsing/searching scholars from bundled assets.
/// For detailed scholar information, use [MohdithInfo] via [MohdithService.getById].
@freezed
abstract class MohdithItem with _$MohdithItem implements ReferenceItem {
  const factory MohdithItem({
    @JsonKey(name: 'key') required String id,
    @JsonKey(name: 'value') required String name,
  }) = _MohdithItem;

  factory MohdithItem.fromJson(Map<String, dynamic> json) =>
      _$MohdithItemFromJson(json);
}
