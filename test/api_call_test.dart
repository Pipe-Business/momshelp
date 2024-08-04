import 'package:momhelp/api/api_call.dart';

void main() async {
  final data = await getAirData(date: "2024-08-04", time: "PM10");
  print(data);
  final weather = await getWeatherData(cityName: "seoul");
  print(weather);
}