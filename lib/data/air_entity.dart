import 'package:freezed_annotation/freezed_annotation.dart';

part 'air_entity.freezed.dart';

part 'air_entity.g.dart';

@freezed
class AirQualityResponse with _$AirQualityResponse {
  const factory AirQualityResponse({
    required AirQualityBody body,
  }) = _AirQualityResponse;

  factory AirQualityResponse.fromJson(Map<String, dynamic> json) =>
      _$AirQualityResponseFromJson(json);
}

@freezed
class AirQualityBody with _$AirQualityBody {
  const factory AirQualityBody({
    required int totalCount,
    required List<AirQualityItem> items,
  }) = _AirQualityBody;

  factory AirQualityBody.fromJson(Map<String, dynamic> json) =>
      _$AirQualityBodyFromJson(json);
}

@freezed
class AirQualityItem with _$AirQualityItem {
  const factory AirQualityItem({
    String? imageUrl1,
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
    String? actionKnack,
  }) = _AirQualityItem;

  factory AirQualityItem.fromJson(Map<String, dynamic> json) =>
      _$AirQualityItemFromJson(json);
}
