import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required String weatherTitle,
    required String weatherDescription,
    required String weatherIconUrl,
    required double temperature,
    required double feelsLike,
    required double pressure,
    required double humidity,
    required double tempLow,
    required double tempHigh,
    required double visibility,
    required double windSpeed,
    required double precipitationProbability,
    required double cloudiness,
    required DateTime timeOfData,
    required DateTime sunriseTime,
    required DateTime sunsetTime,
    required String cityName,
  }) = _Weather;
}
