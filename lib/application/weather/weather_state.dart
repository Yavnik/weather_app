part of 'weather_bloc.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.loading({required String message}) = _Loading;
  const factory WeatherState.error() = _Error; //TODO: Pass the [WeatherFailure] so UI can display which error occoured
  const factory WeatherState.weatherFetched({
    required Weather weather,
    required List<Weather> hourlyForecast,
    required List<Weather> tomorrowForecast,
    required List<Weather> totalForecast,
    required int timeFrameIndex,
  }) = _WeatherFetched;
}
