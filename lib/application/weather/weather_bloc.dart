import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/domain/weather/i_weather_repository.dart';
import 'package:weather_app/domain/weather/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';
part 'weather_bloc.freezed.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final LatLng _location;
  final IWeatherRepository _weatherRepository;

  WeatherBloc(this._location, this._weatherRepository) : super(const WeatherState.loading(message: 'Fetching Weather Data...')) {
    on<WeatherEvent>((event, emit) async {
      await event.map(
        fetchWeather: (value) async {
          emit(const WeatherState.loading(message: 'Fetching Weather Data...'));
          final res = await _weatherRepository.fetchWeather(location: _location);
          await res.fold(
            (failure) {
              emit(const WeatherState.error());
            },
            (weather) async {
              final res = await _weatherRepository.fetchWeatherForecast(location: _location);
              res.fold(
                (failure) {
                  emit(const WeatherState.error());
                },
                (forecast) {
                  final List<Weather> hourlyForecast =
                      forecast.sublist(0, 6); // Get first 6 [Weather] instances from [forecast] to display on [HomeScreen]
                  final List<Weather> tomorrowForecast = forecast.where((weather) {
                    // Get all the [Weather] instances for Date = Today + 1 (ie Tomorrow)
                    final DateTime current = weather.timeOfData.toLocal();
                    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
                    return current.day == tomorrow.day && current.month == tomorrow.month && current.year == tomorrow.year;
                  }).toList();

                  emit(WeatherState.weatherFetched(
                    weather: weather,
                    hourlyForecast: hourlyForecast,
                    tomorrowForecast: tomorrowForecast,
                    totalForecast: forecast,
                    timeFrameIndex: 0,
                  ));
                },
              );
            },
          );
        },

        /// [ChangeTimeFrame] has been defered to [WetherBloc] instead of doing it in UI
        /// because of future possibility of minimizing API calls and fetching data only as required.
        changeTimeFrame: (value) {
          state.mapOrNull(
            weatherFetched: (weatherFetchedState) {
              emit(weatherFetchedState.copyWith(timeFrameIndex: value.timeFrameIndex));
            },
          );
        },
      );
    });
  }
}
