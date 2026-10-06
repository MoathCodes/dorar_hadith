// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mohdith_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MohdithItem {

@JsonKey(name: 'key') String get id;@JsonKey(name: 'value') String get name; bool get currentSelectable; List<String> get historicalNames;
/// Create a copy of MohdithItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MohdithItemCopyWith<MohdithItem> get copyWith => _$MohdithItemCopyWithImpl<MohdithItem>(this as MohdithItem, _$identity);

  /// Serializes this MohdithItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MohdithItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MohdithItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.currentSelectable, _this.currentSelectable) || other.currentSelectable == _this.currentSelectable)&&const DeepCollectionEquality().equals(other.historicalNames, _this.historicalNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MohdithItem;
  return Object.hash(runtimeType,_this.id,_this.name,_this.currentSelectable,const DeepCollectionEquality().hash(_this.historicalNames));
}

@override
String toString() {
  final _this = this as MohdithItem;
  return 'MohdithItem(id: ${_this.id}, name: ${_this.name}, currentSelectable: ${_this.currentSelectable}, historicalNames: ${_this.historicalNames})';
}


}

/// @nodoc
abstract mixin class $MohdithItemCopyWith<$Res>  {
  factory $MohdithItemCopyWith(MohdithItem value, $Res Function(MohdithItem) _then) = _$MohdithItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'key') String id,@JsonKey(name: 'value') String name, bool currentSelectable, List<String> historicalNames
});




}
/// @nodoc
class _$MohdithItemCopyWithImpl<$Res>
    implements $MohdithItemCopyWith<$Res> {
  _$MohdithItemCopyWithImpl(this._self, this._then);

  final MohdithItem _self;
  final $Res Function(MohdithItem) _then;

/// Create a copy of MohdithItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? currentSelectable = null,Object? historicalNames = null,}) {
  return _then(MohdithItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentSelectable: null == currentSelectable ? _self.currentSelectable : currentSelectable // ignore: cast_nullable_to_non_nullable
as bool,historicalNames: null == historicalNames ? _self.historicalNames : historicalNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MohdithItem].
extension MohdithItemPatterns on MohdithItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MohdithItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MohdithItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MohdithItem value)  $default,){
final _that = this;
switch (_that) {
case _MohdithItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MohdithItem value)?  $default,){
final _that = this;
switch (_that) {
case _MohdithItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String id, @JsonKey(name: 'value')  String name,  bool currentSelectable,  List<String> historicalNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MohdithItem() when $default != null:
return $default(_that.id,_that.name,_that.currentSelectable,_that.historicalNames);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String id, @JsonKey(name: 'value')  String name,  bool currentSelectable,  List<String> historicalNames)  $default,) {final _that = this;
switch (_that) {
case _MohdithItem():
return $default(_that.id,_that.name,_that.currentSelectable,_that.historicalNames);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'key')  String id, @JsonKey(name: 'value')  String name,  bool currentSelectable,  List<String> historicalNames)?  $default,) {final _that = this;
switch (_that) {
case _MohdithItem() when $default != null:
return $default(_that.id,_that.name,_that.currentSelectable,_that.historicalNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MohdithItem implements MohdithItem {
  const _MohdithItem({@JsonKey(name: 'key') required this.id, @JsonKey(name: 'value') required this.name, this.currentSelectable = true, this.historicalNames = const []});
  factory _MohdithItem.fromJson(Map<String, dynamic> json) => _$MohdithItemFromJson(json);

@override@JsonKey(name: 'key') final  String id;
@override@JsonKey(name: 'value') final  String name;
@override@JsonKey() final  bool currentSelectable;
@override@JsonKey() final  List<String> historicalNames;

/// Create a copy of MohdithItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MohdithItemCopyWith<_MohdithItem> get copyWith => __$MohdithItemCopyWithImpl<_MohdithItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MohdithItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MohdithItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentSelectable, currentSelectable) || other.currentSelectable == currentSelectable)&&const DeepCollectionEquality().equals(other.historicalNames, historicalNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,currentSelectable,const DeepCollectionEquality().hash(historicalNames));
}

@override
String toString() {
    return 'MohdithItem(id: $id, name: $name, currentSelectable: $currentSelectable, historicalNames: $historicalNames)';
}


}

/// @nodoc
abstract mixin class _$MohdithItemCopyWith<$Res> implements $MohdithItemCopyWith<$Res> {
  factory _$MohdithItemCopyWith(_MohdithItem value, $Res Function(_MohdithItem) _then) = __$MohdithItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'key') String id,@JsonKey(name: 'value') String name, bool currentSelectable, List<String> historicalNames
});




}
/// @nodoc
class __$MohdithItemCopyWithImpl<$Res>
    implements _$MohdithItemCopyWith<$Res> {
  __$MohdithItemCopyWithImpl(this._self, this._then);

  final _MohdithItem _self;
  final $Res Function(_MohdithItem) _then;

/// Create a copy of MohdithItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? currentSelectable = null,Object? historicalNames = null,}) {
  return _then(_MohdithItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentSelectable: null == currentSelectable ? _self.currentSelectable : currentSelectable // ignore: cast_nullable_to_non_nullable
as bool,historicalNames: null == historicalNames ? _self.historicalNames : historicalNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
