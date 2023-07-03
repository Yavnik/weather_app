part of 'weather_bloc.dart';

@freezed
class WeatherEvent with _$WeatherEvent {
  const factory WeatherEvent.fetchWeather() = _FetchWeather;
  const factory WeatherEvent.changeTimeFrame({required int timeFrameIndex}) = _ChangeTimeFrame;
}
