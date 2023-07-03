import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/application/weather/weather_bloc.dart';
import 'package:weather_app/domain/weather/i_weather_repository.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/domain/weather/weather_failure.dart';
import 'package:weather_app/infrastructure/weather/weather_repository.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeather extends Mock implements Weather {}

void main() {
  group('WeatherBloc', () {
    late Weather weather;
    late IWeatherRepository weatherRepository;
    late WeatherBloc weatherBloc;
    LatLng location = const LatLng(6.9, 4.2);

    setUp(() async {
      weather = MockWeather();
      weatherRepository = MockWeatherRepository();
      when(() => weather.cityName).thenReturn('cityName');
      when(() => weather.temperature).thenReturn(28.04);
      when(() => weather.visibility).thenReturn(10000);
      when(() => weather.timeOfData).thenReturn(DateTime(200));
      when(
        () => weatherRepository.fetchWeather(location: location),
      ).thenAnswer((_) => Future.value(right(weather)));
      when(
        () => weatherRepository.fetchWeatherForecast(location: location),
      ).thenAnswer((_) => Future.value(right([weather, weather, weather, weather, weather, weather, weather, weather, weather, weather])));
      weatherBloc = WeatherBloc(location, weatherRepository);
    });

    test('initial state is correct', () {
      final weatherBloc = WeatherBloc(location, weatherRepository);
      expect(weatherBloc.state, const WeatherState.loading(message: 'Fetching Weather Data...'));
    });

    group('fetchWeather', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits nothing when no event added',
        build: () => weatherBloc,
        act: (bloc) => bloc,
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits WeatherState.error() when fetchWeather throws error',
        setUp: () async {
          when(
            () => weatherRepository.fetchWeather(location: location),
          ).thenAnswer((_) => Future.value(left(const WeatherFailure.unexpected())));
        },
        build: () => weatherBloc,
        act: (bloc) => bloc.add(const WeatherEvent.fetchWeather()),
        expect: () => <WeatherState>[
          const WeatherState.loading(message: 'Fetching Weather Data...'),
          const WeatherState.error(),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits [loading, weatherFetched] when fetchWeather returns Weather, List<Weather>',
        build: () => weatherBloc,
        act: (bloc) => bloc.add(const WeatherEvent.fetchWeather()),
        expect: () => <dynamic>[
          const WeatherState.loading(message: 'Fetching Weather Data...'),
          isA<WeatherState>().having(
              (w) => w,
              'weatherState',
              WeatherState.weatherFetched(
                weather: weather,
                hourlyForecast: [weather, weather, weather, weather, weather, weather],
                timeFrameIndex: 0,
                tomorrowForecast: [],
                totalForecast: [weather, weather, weather, weather, weather, weather, weather, weather, weather, weather],
              ))
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits nothing when fetchWeather event is not added',
        build: () => weatherBloc,
        seed: () => WeatherState.weatherFetched(
          weather: weather,
          hourlyForecast: [weather, weather, weather, weather, weather, weather],
          timeFrameIndex: 0,
          tomorrowForecast: [],
          totalForecast: [weather, weather, weather, weather, weather, weather, weather, weather, weather, weather],
        ),
        act: (bloc) => bloc,
        expect: () => <WeatherState>[],
        verify: (_) {
          verifyNever(() => weatherRepository.fetchWeather(location: location));
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'invokes fetchWeather() with correct location',
        build: () => weatherBloc,
        seed: () => WeatherState.weatherFetched(
          weather: weather,
          hourlyForecast: [weather, weather, weather, weather, weather, weather],
          timeFrameIndex: 0,
          tomorrowForecast: [],
          totalForecast: [weather, weather, weather, weather, weather, weather, weather, weather, weather, weather],
        ),
        act: (bloc) => bloc.add(const WeatherEvent.fetchWeather()),
        verify: (_) {
          verify(() => weatherRepository.fetchWeather(location: location)).called(1);
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits [loading,error] when exception is thrown',
        setUp: () async {
          when(
            () => weatherRepository.fetchWeather(location: location),
          ).thenAnswer((_) => Future.value(left(const WeatherFailure.unexpected())));
        },
        build: () => weatherBloc,
        act: (bloc) => bloc.add(const WeatherEvent.fetchWeather()),
        expect: () => <WeatherState>[
          const WeatherState.loading(message: 'Fetching Weather Data...'),
          const WeatherState.error(),
        ],
      );
    });
  });
}
