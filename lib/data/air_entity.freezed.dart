// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'air_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AirQualityResponse _$AirQualityResponseFromJson(Map<String, dynamic> json) {
  return _AirQualityResponse.fromJson(json);
}

/// @nodoc
mixin _$AirQualityResponse {
  AirQualityBody get body => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AirQualityResponseCopyWith<AirQualityResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AirQualityResponseCopyWith<$Res> {
  factory $AirQualityResponseCopyWith(
          AirQualityResponse value, $Res Function(AirQualityResponse) then) =
      _$AirQualityResponseCopyWithImpl<$Res, AirQualityResponse>;
  @useResult
  $Res call({AirQualityBody body});

  $AirQualityBodyCopyWith<$Res> get body;
}

/// @nodoc
class _$AirQualityResponseCopyWithImpl<$Res, $Val extends AirQualityResponse>
    implements $AirQualityResponseCopyWith<$Res> {
  _$AirQualityResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? body = null,
  }) {
    return _then(_value.copyWith(
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as AirQualityBody,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AirQualityBodyCopyWith<$Res> get body {
    return $AirQualityBodyCopyWith<$Res>(_value.body, (value) {
      return _then(_value.copyWith(body: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AirQualityResponseImplCopyWith<$Res>
    implements $AirQualityResponseCopyWith<$Res> {
  factory _$$AirQualityResponseImplCopyWith(_$AirQualityResponseImpl value,
          $Res Function(_$AirQualityResponseImpl) then) =
      __$$AirQualityResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AirQualityBody body});

  @override
  $AirQualityBodyCopyWith<$Res> get body;
}

/// @nodoc
class __$$AirQualityResponseImplCopyWithImpl<$Res>
    extends _$AirQualityResponseCopyWithImpl<$Res, _$AirQualityResponseImpl>
    implements _$$AirQualityResponseImplCopyWith<$Res> {
  __$$AirQualityResponseImplCopyWithImpl(_$AirQualityResponseImpl _value,
      $Res Function(_$AirQualityResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? body = null,
  }) {
    return _then(_$AirQualityResponseImpl(
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as AirQualityBody,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AirQualityResponseImpl implements _AirQualityResponse {
  const _$AirQualityResponseImpl({required this.body});

  factory _$AirQualityResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AirQualityResponseImplFromJson(json);

  @override
  final AirQualityBody body;

  @override
  String toString() {
    return 'AirQualityResponse(body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AirQualityResponseImpl &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, body);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AirQualityResponseImplCopyWith<_$AirQualityResponseImpl> get copyWith =>
      __$$AirQualityResponseImplCopyWithImpl<_$AirQualityResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AirQualityResponseImplToJson(
      this,
    );
  }
}

abstract class _AirQualityResponse implements AirQualityResponse {
  const factory _AirQualityResponse({required final AirQualityBody body}) =
      _$AirQualityResponseImpl;

  factory _AirQualityResponse.fromJson(Map<String, dynamic> json) =
      _$AirQualityResponseImpl.fromJson;

  @override
  AirQualityBody get body;
  @override
  @JsonKey(ignore: true)
  _$$AirQualityResponseImplCopyWith<_$AirQualityResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AirQualityBody _$AirQualityBodyFromJson(Map<String, dynamic> json) {
  return _AirQualityBody.fromJson(json);
}

/// @nodoc
mixin _$AirQualityBody {
  int get totalCount => throw _privateConstructorUsedError;
  List<AirQualityItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AirQualityBodyCopyWith<AirQualityBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AirQualityBodyCopyWith<$Res> {
  factory $AirQualityBodyCopyWith(
          AirQualityBody value, $Res Function(AirQualityBody) then) =
      _$AirQualityBodyCopyWithImpl<$Res, AirQualityBody>;
  @useResult
  $Res call({int totalCount, List<AirQualityItem> items});
}

/// @nodoc
class _$AirQualityBodyCopyWithImpl<$Res, $Val extends AirQualityBody>
    implements $AirQualityBodyCopyWith<$Res> {
  _$AirQualityBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AirQualityItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AirQualityBodyImplCopyWith<$Res>
    implements $AirQualityBodyCopyWith<$Res> {
  factory _$$AirQualityBodyImplCopyWith(_$AirQualityBodyImpl value,
          $Res Function(_$AirQualityBodyImpl) then) =
      __$$AirQualityBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalCount, List<AirQualityItem> items});
}

/// @nodoc
class __$$AirQualityBodyImplCopyWithImpl<$Res>
    extends _$AirQualityBodyCopyWithImpl<$Res, _$AirQualityBodyImpl>
    implements _$$AirQualityBodyImplCopyWith<$Res> {
  __$$AirQualityBodyImplCopyWithImpl(
      _$AirQualityBodyImpl _value, $Res Function(_$AirQualityBodyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? items = null,
  }) {
    return _then(_$AirQualityBodyImpl(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AirQualityItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AirQualityBodyImpl implements _AirQualityBody {
  const _$AirQualityBodyImpl(
      {required this.totalCount, required final List<AirQualityItem> items})
      : _items = items;

  factory _$AirQualityBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$AirQualityBodyImplFromJson(json);

  @override
  final int totalCount;
  final List<AirQualityItem> _items;
  @override
  List<AirQualityItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'AirQualityBody(totalCount: $totalCount, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AirQualityBodyImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalCount, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AirQualityBodyImplCopyWith<_$AirQualityBodyImpl> get copyWith =>
      __$$AirQualityBodyImplCopyWithImpl<_$AirQualityBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AirQualityBodyImplToJson(
      this,
    );
  }
}

abstract class _AirQualityBody implements AirQualityBody {
  const factory _AirQualityBody(
      {required final int totalCount,
      required final List<AirQualityItem> items}) = _$AirQualityBodyImpl;

  factory _AirQualityBody.fromJson(Map<String, dynamic> json) =
      _$AirQualityBodyImpl.fromJson;

  @override
  int get totalCount;
  @override
  List<AirQualityItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$AirQualityBodyImplCopyWith<_$AirQualityBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AirQualityItem _$AirQualityItemFromJson(Map<String, dynamic> json) {
  return _AirQualityItem.fromJson(json);
}

/// @nodoc
mixin _$AirQualityItem {
  String? get imageUrl1 => throw _privateConstructorUsedError;
  String? get imageUrl2 => throw _privateConstructorUsedError;
  String? get imageUrl3 => throw _privateConstructorUsedError;
  String? get imageUrl4 => throw _privateConstructorUsedError;
  String? get imageUrl5 => throw _privateConstructorUsedError;
  String? get imageUrl6 => throw _privateConstructorUsedError;
  String? get informCode => throw _privateConstructorUsedError;
  String? get informCause => throw _privateConstructorUsedError;
  String? get informOverall => throw _privateConstructorUsedError;
  String? get informData => throw _privateConstructorUsedError;
  String? get informGrade => throw _privateConstructorUsedError;
  String? get dataTime => throw _privateConstructorUsedError;
  String? get actionKnack => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AirQualityItemCopyWith<AirQualityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AirQualityItemCopyWith<$Res> {
  factory $AirQualityItemCopyWith(
          AirQualityItem value, $Res Function(AirQualityItem) then) =
      _$AirQualityItemCopyWithImpl<$Res, AirQualityItem>;
  @useResult
  $Res call(
      {String? imageUrl1,
      String? imageUrl2,
      String? imageUrl3,
      String? imageUrl4,
      String? imageUrl5,
      String? imageUrl6,
      String? informCode,
      String? informCause,
      String? informOverall,
      String? informData,
      String? informGrade,
      String? dataTime,
      String? actionKnack});
}

/// @nodoc
class _$AirQualityItemCopyWithImpl<$Res, $Val extends AirQualityItem>
    implements $AirQualityItemCopyWith<$Res> {
  _$AirQualityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl1 = freezed,
    Object? imageUrl2 = freezed,
    Object? imageUrl3 = freezed,
    Object? imageUrl4 = freezed,
    Object? imageUrl5 = freezed,
    Object? imageUrl6 = freezed,
    Object? informCode = freezed,
    Object? informCause = freezed,
    Object? informOverall = freezed,
    Object? informData = freezed,
    Object? informGrade = freezed,
    Object? dataTime = freezed,
    Object? actionKnack = freezed,
  }) {
    return _then(_value.copyWith(
      imageUrl1: freezed == imageUrl1
          ? _value.imageUrl1
          : imageUrl1 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl2: freezed == imageUrl2
          ? _value.imageUrl2
          : imageUrl2 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl3: freezed == imageUrl3
          ? _value.imageUrl3
          : imageUrl3 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl4: freezed == imageUrl4
          ? _value.imageUrl4
          : imageUrl4 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl5: freezed == imageUrl5
          ? _value.imageUrl5
          : imageUrl5 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl6: freezed == imageUrl6
          ? _value.imageUrl6
          : imageUrl6 // ignore: cast_nullable_to_non_nullable
              as String?,
      informCode: freezed == informCode
          ? _value.informCode
          : informCode // ignore: cast_nullable_to_non_nullable
              as String?,
      informCause: freezed == informCause
          ? _value.informCause
          : informCause // ignore: cast_nullable_to_non_nullable
              as String?,
      informOverall: freezed == informOverall
          ? _value.informOverall
          : informOverall // ignore: cast_nullable_to_non_nullable
              as String?,
      informData: freezed == informData
          ? _value.informData
          : informData // ignore: cast_nullable_to_non_nullable
              as String?,
      informGrade: freezed == informGrade
          ? _value.informGrade
          : informGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      dataTime: freezed == dataTime
          ? _value.dataTime
          : dataTime // ignore: cast_nullable_to_non_nullable
              as String?,
      actionKnack: freezed == actionKnack
          ? _value.actionKnack
          : actionKnack // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AirQualityItemImplCopyWith<$Res>
    implements $AirQualityItemCopyWith<$Res> {
  factory _$$AirQualityItemImplCopyWith(_$AirQualityItemImpl value,
          $Res Function(_$AirQualityItemImpl) then) =
      __$$AirQualityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? imageUrl1,
      String? imageUrl2,
      String? imageUrl3,
      String? imageUrl4,
      String? imageUrl5,
      String? imageUrl6,
      String? informCode,
      String? informCause,
      String? informOverall,
      String? informData,
      String? informGrade,
      String? dataTime,
      String? actionKnack});
}

/// @nodoc
class __$$AirQualityItemImplCopyWithImpl<$Res>
    extends _$AirQualityItemCopyWithImpl<$Res, _$AirQualityItemImpl>
    implements _$$AirQualityItemImplCopyWith<$Res> {
  __$$AirQualityItemImplCopyWithImpl(
      _$AirQualityItemImpl _value, $Res Function(_$AirQualityItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl1 = freezed,
    Object? imageUrl2 = freezed,
    Object? imageUrl3 = freezed,
    Object? imageUrl4 = freezed,
    Object? imageUrl5 = freezed,
    Object? imageUrl6 = freezed,
    Object? informCode = freezed,
    Object? informCause = freezed,
    Object? informOverall = freezed,
    Object? informData = freezed,
    Object? informGrade = freezed,
    Object? dataTime = freezed,
    Object? actionKnack = freezed,
  }) {
    return _then(_$AirQualityItemImpl(
      imageUrl1: freezed == imageUrl1
          ? _value.imageUrl1
          : imageUrl1 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl2: freezed == imageUrl2
          ? _value.imageUrl2
          : imageUrl2 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl3: freezed == imageUrl3
          ? _value.imageUrl3
          : imageUrl3 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl4: freezed == imageUrl4
          ? _value.imageUrl4
          : imageUrl4 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl5: freezed == imageUrl5
          ? _value.imageUrl5
          : imageUrl5 // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl6: freezed == imageUrl6
          ? _value.imageUrl6
          : imageUrl6 // ignore: cast_nullable_to_non_nullable
              as String?,
      informCode: freezed == informCode
          ? _value.informCode
          : informCode // ignore: cast_nullable_to_non_nullable
              as String?,
      informCause: freezed == informCause
          ? _value.informCause
          : informCause // ignore: cast_nullable_to_non_nullable
              as String?,
      informOverall: freezed == informOverall
          ? _value.informOverall
          : informOverall // ignore: cast_nullable_to_non_nullable
              as String?,
      informData: freezed == informData
          ? _value.informData
          : informData // ignore: cast_nullable_to_non_nullable
              as String?,
      informGrade: freezed == informGrade
          ? _value.informGrade
          : informGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      dataTime: freezed == dataTime
          ? _value.dataTime
          : dataTime // ignore: cast_nullable_to_non_nullable
              as String?,
      actionKnack: freezed == actionKnack
          ? _value.actionKnack
          : actionKnack // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AirQualityItemImpl implements _AirQualityItem {
  const _$AirQualityItemImpl(
      {this.imageUrl1,
      this.imageUrl2,
      this.imageUrl3,
      this.imageUrl4,
      this.imageUrl5,
      this.imageUrl6,
      this.informCode,
      this.informCause,
      this.informOverall,
      this.informData,
      this.informGrade,
      this.dataTime,
      this.actionKnack});

  factory _$AirQualityItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AirQualityItemImplFromJson(json);

  @override
  final String? imageUrl1;
  @override
  final String? imageUrl2;
  @override
  final String? imageUrl3;
  @override
  final String? imageUrl4;
  @override
  final String? imageUrl5;
  @override
  final String? imageUrl6;
  @override
  final String? informCode;
  @override
  final String? informCause;
  @override
  final String? informOverall;
  @override
  final String? informData;
  @override
  final String? informGrade;
  @override
  final String? dataTime;
  @override
  final String? actionKnack;

  @override
  String toString() {
    return 'AirQualityItem(imageUrl1: $imageUrl1, imageUrl2: $imageUrl2, imageUrl3: $imageUrl3, imageUrl4: $imageUrl4, imageUrl5: $imageUrl5, imageUrl6: $imageUrl6, informCode: $informCode, informCause: $informCause, informOverall: $informOverall, informData: $informData, informGrade: $informGrade, dataTime: $dataTime, actionKnack: $actionKnack)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AirQualityItemImpl &&
            (identical(other.imageUrl1, imageUrl1) ||
                other.imageUrl1 == imageUrl1) &&
            (identical(other.imageUrl2, imageUrl2) ||
                other.imageUrl2 == imageUrl2) &&
            (identical(other.imageUrl3, imageUrl3) ||
                other.imageUrl3 == imageUrl3) &&
            (identical(other.imageUrl4, imageUrl4) ||
                other.imageUrl4 == imageUrl4) &&
            (identical(other.imageUrl5, imageUrl5) ||
                other.imageUrl5 == imageUrl5) &&
            (identical(other.imageUrl6, imageUrl6) ||
                other.imageUrl6 == imageUrl6) &&
            (identical(other.informCode, informCode) ||
                other.informCode == informCode) &&
            (identical(other.informCause, informCause) ||
                other.informCause == informCause) &&
            (identical(other.informOverall, informOverall) ||
                other.informOverall == informOverall) &&
            (identical(other.informData, informData) ||
                other.informData == informData) &&
            (identical(other.informGrade, informGrade) ||
                other.informGrade == informGrade) &&
            (identical(other.dataTime, dataTime) ||
                other.dataTime == dataTime) &&
            (identical(other.actionKnack, actionKnack) ||
                other.actionKnack == actionKnack));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      imageUrl1,
      imageUrl2,
      imageUrl3,
      imageUrl4,
      imageUrl5,
      imageUrl6,
      informCode,
      informCause,
      informOverall,
      informData,
      informGrade,
      dataTime,
      actionKnack);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AirQualityItemImplCopyWith<_$AirQualityItemImpl> get copyWith =>
      __$$AirQualityItemImplCopyWithImpl<_$AirQualityItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AirQualityItemImplToJson(
      this,
    );
  }
}

abstract class _AirQualityItem implements AirQualityItem {
  const factory _AirQualityItem(
      {final String? imageUrl1,
      final String? imageUrl2,
      final String? imageUrl3,
      final String? imageUrl4,
      final String? imageUrl5,
      final String? imageUrl6,
      final String? informCode,
      final String? informCause,
      final String? informOverall,
      final String? informData,
      final String? informGrade,
      final String? dataTime,
      final String? actionKnack}) = _$AirQualityItemImpl;

  factory _AirQualityItem.fromJson(Map<String, dynamic> json) =
      _$AirQualityItemImpl.fromJson;

  @override
  String? get imageUrl1;
  @override
  String? get imageUrl2;
  @override
  String? get imageUrl3;
  @override
  String? get imageUrl4;
  @override
  String? get imageUrl5;
  @override
  String? get imageUrl6;
  @override
  String? get informCode;
  @override
  String? get informCause;
  @override
  String? get informOverall;
  @override
  String? get informData;
  @override
  String? get informGrade;
  @override
  String? get dataTime;
  @override
  String? get actionKnack;
  @override
  @JsonKey(ignore: true)
  _$$AirQualityItemImplCopyWith<_$AirQualityItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
