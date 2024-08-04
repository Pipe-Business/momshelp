// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AirQualityResponseImpl _$$AirQualityResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AirQualityResponseImpl(
      body: AirQualityBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AirQualityResponseImplToJson(
        _$AirQualityResponseImpl instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

_$AirQualityBodyImpl _$$AirQualityBodyImplFromJson(Map<String, dynamic> json) =>
    _$AirQualityBodyImpl(
      totalCount: (json['totalCount'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => AirQualityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AirQualityBodyImplToJson(
        _$AirQualityBodyImpl instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
    };

_$AirQualityItemImpl _$$AirQualityItemImplFromJson(Map<String, dynamic> json) =>
    _$AirQualityItemImpl(
      imageUrl1: json['imageUrl1'] as String?,
      imageUrl2: json['imageUrl2'] as String?,
      imageUrl3: json['imageUrl3'] as String?,
      imageUrl4: json['imageUrl4'] as String?,
      imageUrl5: json['imageUrl5'] as String?,
      imageUrl6: json['imageUrl6'] as String?,
      informCode: json['informCode'] as String?,
      informCause: json['informCause'] as String?,
      informOverall: json['informOverall'] as String?,
      informData: json['informData'] as String?,
      informGrade: json['informGrade'] as String?,
      dataTime: json['dataTime'] as String?,
      actionKnack: json['actionKnack'] as String?,
    );

Map<String, dynamic> _$$AirQualityItemImplToJson(
        _$AirQualityItemImpl instance) =>
    <String, dynamic>{
      'imageUrl1': instance.imageUrl1,
      'imageUrl2': instance.imageUrl2,
      'imageUrl3': instance.imageUrl3,
      'imageUrl4': instance.imageUrl4,
      'imageUrl5': instance.imageUrl5,
      'imageUrl6': instance.imageUrl6,
      'informCode': instance.informCode,
      'informCause': instance.informCause,
      'informOverall': instance.informOverall,
      'informData': instance.informData,
      'informGrade': instance.informGrade,
      'dataTime': instance.dataTime,
      'actionKnack': instance.actionKnack,
    };
