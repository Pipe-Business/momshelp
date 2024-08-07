import 'package:dio/dio.dart';

import '../data/air_entity.dart';
import '../data/weather_entity.dart';
import '../utils/env.dart';

Future<AirQualityResponse> getAirData(
    {required String date, required String time}) async {
  Dio dio = Dio();
  String url =
      'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMinuDustFrcstDspth';

  // 요청 파라미터 설정
  Map<String, dynamic> queryParams = {
    'serviceKey': Env.airApikey,
    'returnType': 'json',
    'numOfRows': 100,
    'pageNo': 1,
    'searchDate': date,
    'InformCode': time
  };

  try {
    // API 요청
    Response response = await dio.get(url, queryParameters: queryParams);
    print(response.data);

    // 응답을 JSON으로 디코딩
    Map<String, dynamic> jsonResponse = response.data;
    print(jsonResponse);

    // JSON 데이터를 AirQualityResponse로 매핑
    AirQualityResponse airQualityResponse =
        AirQualityResponse.fromJson(jsonResponse['response']);

    return airQualityResponse;
  } catch (e, stack) {
    // 오류 처리
    print(stack);

    throw e.toString();
  }
}
Future<WeatherData> fetchGetWeatherDataWithLatLon({required String lat,required String lon})async {
  final Dio _dio = Dio();
  print("fetch function");
  final String _apiKey = Env.weatherApikey; // 여기에 실제 API 키를 넣으세요.
  print("lat: $lat, lon: $lon");

  try {
    final response = await _dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'lat':double.parse(lat),
        'lon':double.parse(lon),
        'appid': _apiKey,
        'units': 'metric', // 섭씨 온도로 데이터를 받기 위한 옵션
      },
    );
    print(response.data);

    // JSON 응답을 WeatherData 모델로 변환
    return WeatherData.fromJson(response.data);
  } catch (e) {
    // 오류 처리
    print('Error fetching weather data: $e');
    rethrow;
  }
}

Future<WeatherData> getWeatherData({required String cityName}) async {
  final Dio _dio = Dio();
  final String _apiKey = Env.weatherApikey; // 여기에 실제 API 키를 넣으세요.

  try {
    final response = await _dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': cityName,
        'appid': _apiKey,
        'units': 'metric', // 섭씨 온도로 데이터를 받기 위한 옵션
      },
    );

    // JSON 응답을 WeatherData 모델로 변환
    return WeatherData.fromJson(response.data);
  } catch (e) {
    // 오류 처리
    print('Error fetching weather data: $e');
    rethrow;
  }
}
