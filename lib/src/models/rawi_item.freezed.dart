// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rawi_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RawiItem {

@JsonKey(name: 'key') String get id;@JsonKey(name: 'value') String get name;
/// Create a copy of RawiItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawiItemCopyWith<RawiItem> get copyWith => _$RawiItemCopyWithImpl<RawiItem>(this as RawiItem, _$identity);

  /// Serializes this RawiItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawiItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'RawiItem(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $RawiItemCopyWith<$Res>  {
  factory $RawiItemCopyWith(RawiItem value, $Res Function(RawiItem) _then) = _$RawiItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'key') String id,@JsonKey(name: 'value') String name
});




}
/// @nodoc
class _$RawiItemCopyWithImpl<$Res>
    implements $RawiItemCopyWith<$Res> {
  _$RawiItemCopyWithImpl(this._self, this._then);

  final RawiItem _self;
  final $Res Function(RawiItem) _then;

/// Create a copy of RawiItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RawiItem].
extension RawiItemPatterns on RawiItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RawiItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RawiItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RawiItem value)  $default,){
final _that = this;
switch (_that) {
case _RawiItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RawiItem value)?  $default,){
final _that = this;
switch (_that) {
case _RawiItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String id, @JsonKey(name: 'value')  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RawiItem() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String id, @JsonKey(name: 'value')  String name)  $default,) {final _that = this;
switch (_that) {
case _RawiItem():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'key')  String id, @JsonKey(name: 'value')  String name)?  $default,) {final _that = this;
switch (_that) {
case _RawiItem() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RawiItem implements RawiItem {
  const _RawiItem({@JsonKey(name: 'key') required this.id, @JsonKey(name: 'value') required this.name});
  factory _RawiItem.fromJson(Map<String, dynamic> json) => _$RawiItemFromJson(json);

@override@JsonKey(name: 'key') final  String id;
@override@JsonKey(name: 'value') final  String name;

/// Create a copy of RawiItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawiItemCopyWith<_RawiItem> get copyWith => __$RawiItemCopyWithImpl<_RawiItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RawiItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RawiItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'RawiItem(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$RawiItemCopyWith<$Res> implements $RawiItemCopyWith<$Res> {
  factory _$RawiItemCopyWith(_RawiItem value, $Res Function(_RawiItem) _then) = __$RawiItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'key') String id,@JsonKey(name: 'value') String name
});




}
/// @nodoc
class __$RawiItemCopyWithImpl<$Res>
    implements _$RawiItemCopyWith<$Res> {
  __$RawiItemCopyWithImpl(this._self, this._then);

  final _RawiItem _self;
  final $Res Function(_RawiItem) _then;

/// Create a copy of RawiItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_RawiItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
