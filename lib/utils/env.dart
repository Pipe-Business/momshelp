import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env{
  @EnviedField(varName: 'gem_apikey')
  static const String gemApiKey = _Env.gemApiKey;
  @EnviedField(varName: 'weather_apikey')
  static const String weatherApikey = _Env.weatherApikey;
  @EnviedField(varName: 'air_apikey')
  static const String airApikey = _Env.airApikey;
}
