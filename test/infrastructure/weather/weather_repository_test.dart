import 'package:dartz_test/dartz_test.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/weather/i_weather_repository.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/domain/weather/weather_failure.dart';
import 'package:weather_app/infrastructure/weather/weather_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('WeatherRepository', () {
    late http.Client httpClient;
    late IWeatherRepository weatherRepository;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      weatherRepository = WeatherRepository(httpClient: httpClient);
      FlutterConfig.loadValueForTesting({'OPEN_WEATHER_MAP_API_KEY': 'appid'});
    });

    group('fetchWeather', () {
      const LatLng location = LatLng(6.9, 4.2);
      test('makes correct http request to fetchWeather', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await weatherRepository.fetchWeather(location: location);
        } catch (_) {}
        verify(
          () => httpClient.get(Uri(
            scheme: 'https',
            host: 'api.openweathermap.org',
            path: 'data/2.5/weather',
            queryParameters: {
              'lat': location.latitude.toString(),
              'lon': location.longitude.toString(),
              'units': 'metric',
              'appid': 'appid',
            },
          )),
        ).called(1);
      });

      test('returns WeatherFailure on non-200 response', () async {
        final response = MockResponse();
        const LatLng location = LatLng(6.9, 4.2);

        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          await weatherRepository.fetchWeather(location: location),
          isLeft,
        );
      });

      test('throws WeatherFailure on empty response', () async {
        const LatLng location = LatLng(6.9, 4.2);

        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"results": []}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          await weatherRepository.fetchWeather(location: location),
          isLeftThat(isA<WeatherFailure>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
    "weather": [
        {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04n"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 28.58,
        "feels_like": 33.22,
        "temp_min": 28.58,
        "temp_max": 28.58,
        "pressure": 1004,
        "humidity": 78,
        "sea_level": 1004,
        "grnd_level": 992
    },
    "visibility": 10000,
    "wind": {
        "speed": 4.92,
        "deg": 203,
        "gust": 9.07
    },
    "clouds": {
        "all": 88
    },
    "dt": 1688320792,
    "sys": {
        "country": "IN",
        "sunrise": 1688257515,
        "sunset": 1688306072
    },
    "timezone": 19800,
    "name": "cityName",
    "cod": 200
}
''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          await weatherRepository.fetchWeather(location: const LatLng(22.5046, 73.4714)),
          isRightThat(
            isA<Weather>().having((weather) => weather.cityName, 'cityName', 'cityName'),
          ),
        );
      });
    });

    group('fetchWeatherForecast', () {
      const LatLng location = LatLng(6.9, 4.2);
      test('makes correct http request to fetchWeatherForecast', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await weatherRepository.fetchWeatherForecast(location: location);
        } catch (_) {}
        verify(
          () => httpClient.get(Uri(
            scheme: 'https',
            host: 'api.openweathermap.org',
            path: 'data/2.5/forecast',
            queryParameters: {
              'lat': location.latitude.toString(),
              'lon': location.longitude.toString(),
              'units': 'metric',
              'appid': 'appid',
            },
          )),
        ).called(1);
      });

      test('returns WeatherFailure on non-200 response', () async {
        final response = MockResponse();
        const LatLng location = LatLng(6.9, 4.2);

        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          await weatherRepository.fetchWeatherForecast(location: location),
          isLeft,
        );
      });

      test('throws WeatherFailure on empty response', () async {
        const LatLng location = LatLng(6.9, 4.2);

        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"results": []}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          await weatherRepository.fetchWeatherForecast(location: location),
          isLeftThat(isA<WeatherFailure>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
    "cod": "200",
    "message": 0,
    "cnt": 40,
    "list": [
        {
            "dt": 1688331600,
            "main": {
                "temp": 28.21,
                "feels_like": 32.63,
                "temp_min": 27.47,
                "temp_max": 28.21,
                "pressure": 1004,
                "sea_level": 1004,
                "grnd_level": 991,
                "humidity": 80,
                "temp_kf": 0.74
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 92
            },
            "wind": {
                "speed": 3.69,
                "deg": 197,
                "gust": 8.45
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-02 21:00:00"
        },
        {
            "dt": 1688342400,
            "main": {
                "temp": 27.4,
                "feels_like": 31.26,
                "temp_min": 26.81,
                "temp_max": 27.4,
                "pressure": 1003,
                "sea_level": 1003,
                "grnd_level": 991,
                "humidity": 85,
                "temp_kf": 0.59
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 96
            },
            "wind": {
                "speed": 3.15,
                "deg": 187,
                "gust": 6.93
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-03 00:00:00"
        },
        {
            "dt": 1688353200,
            "main": {
                "temp": 28.44,
                "feels_like": 33.05,
                "temp_min": 28.44,
                "temp_max": 28.44,
                "pressure": 1004,
                "sea_level": 1004,
                "grnd_level": 993,
                "humidity": 79,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 91
            },
            "wind": {
                "speed": 3.75,
                "deg": 200,
                "gust": 5.07
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-03 03:00:00"
        },
        {
            "dt": 1688364000,
            "main": {
                "temp": 32.15,
                "feels_like": 38.39,
                "temp_min": 32.15,
                "temp_max": 32.15,
                "pressure": 1004,
                "sea_level": 1004,
                "grnd_level": 992,
                "humidity": 63,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 803,
                    "main": "Clouds",
                    "description": "broken clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 83
            },
            "wind": {
                "speed": 3.33,
                "deg": 205,
                "gust": 3.05
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-03 06:00:00"
        },
        {
            "dt": 1688374800,
            "main": {
                "temp": 34.56,
                "feels_like": 40.79,
                "temp_min": 34.56,
                "temp_max": 34.56,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 53,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 87
            },
            "wind": {
                "speed": 2.72,
                "deg": 200,
                "gust": 2.06
            },
            "visibility": 10000,
            "pop": 0.17,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-03 09:00:00"
        },
        {
            "dt": 1688385600,
            "main": {
                "temp": 34.44,
                "feels_like": 40.5,
                "temp_min": 34.44,
                "temp_max": 34.44,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 989,
                "humidity": 53,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 88
            },
            "wind": {
                "speed": 2.57,
                "deg": 199,
                "gust": 2.81
            },
            "visibility": 10000,
            "pop": 0.33,
            "rain": {
                "3h": 0.19
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-03 12:00:00"
        },
        {
            "dt": 1688396400,
            "main": {
                "temp": 31.8,
                "feels_like": 37.21,
                "temp_min": 31.8,
                "temp_max": 31.8,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 62,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10n"
                }
            ],
            "clouds": {
                "all": 99
            },
            "wind": {
                "speed": 3.27,
                "deg": 205,
                "gust": 5.87
            },
            "visibility": 10000,
            "pop": 0.27,
            "rain": {
                "3h": 0.11
            },
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-03 15:00:00"
        },
        {
            "dt": 1688407200,
            "main": {
                "temp": 29.29,
                "feels_like": 34.42,
                "temp_min": 29.29,
                "temp_max": 29.29,
                "pressure": 1003,
                "sea_level": 1003,
                "grnd_level": 991,
                "humidity": 75,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 94
            },
            "wind": {
                "speed": 4.45,
                "deg": 204,
                "gust": 8.04
            },
            "visibility": 10000,
            "pop": 0.07,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-03 18:00:00"
        },
        {
            "dt": 1688418000,
            "main": {
                "temp": 28.08,
                "feels_like": 32.62,
                "temp_min": 28.08,
                "temp_max": 28.08,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 82,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 803,
                    "main": "Clouds",
                    "description": "broken clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 80
            },
            "wind": {
                "speed": 4.05,
                "deg": 198,
                "gust": 8
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-03 21:00:00"
        },
        {
            "dt": 1688428800,
            "main": {
                "temp": 27.3,
                "feels_like": 31.23,
                "temp_min": 27.3,
                "temp_max": 27.3,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 87,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 90
            },
            "wind": {
                "speed": 3.52,
                "deg": 190,
                "gust": 6.88
            },
            "visibility": 10000,
            "pop": 0.01,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-04 00:00:00"
        },
        {
            "dt": 1688439600,
            "main": {
                "temp": 29.15,
                "feels_like": 34.5,
                "temp_min": 29.15,
                "temp_max": 29.15,
                "pressure": 1003,
                "sea_level": 1003,
                "grnd_level": 991,
                "humidity": 77,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 4.68,
                "deg": 215,
                "gust": 5.84
            },
            "visibility": 10000,
            "pop": 0.25,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-04 03:00:00"
        },
        {
            "dt": 1688450400,
            "main": {
                "temp": 32.86,
                "feels_like": 38.82,
                "temp_min": 32.86,
                "temp_max": 32.86,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 991,
                "humidity": 59,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 94
            },
            "wind": {
                "speed": 4.01,
                "deg": 234,
                "gust": 4.21
            },
            "visibility": 10000,
            "pop": 0.34,
            "rain": {
                "3h": 0.24
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-04 06:00:00"
        },
        {
            "dt": 1688461200,
            "main": {
                "temp": 32.65,
                "feels_like": 38.3,
                "temp_min": 32.65,
                "temp_max": 32.65,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 59,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 501,
                    "main": "Rain",
                    "description": "moderate rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 97
            },
            "wind": {
                "speed": 4.02,
                "deg": 224,
                "gust": 4.58
            },
            "visibility": 10000,
            "pop": 0.66,
            "rain": {
                "3h": 3.04
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-04 09:00:00"
        },
        {
            "dt": 1688472000,
            "main": {
                "temp": 33.37,
                "feels_like": 38.67,
                "temp_min": 33.37,
                "temp_max": 33.37,
                "pressure": 999,
                "sea_level": 999,
                "grnd_level": 987,
                "humidity": 55,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 98
            },
            "wind": {
                "speed": 3.51,
                "deg": 242,
                "gust": 4.4
            },
            "visibility": 10000,
            "pop": 0.54,
            "rain": {
                "3h": 0.61
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-04 12:00:00"
        },
        {
            "dt": 1688482800,
            "main": {
                "temp": 30.4,
                "feels_like": 35.51,
                "temp_min": 30.4,
                "temp_max": 30.4,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 988,
                "humidity": 68,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 99
            },
            "wind": {
                "speed": 6.02,
                "deg": 212,
                "gust": 8.72
            },
            "visibility": 10000,
            "pop": 0.04,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-04 15:00:00"
        },
        {
            "dt": 1688493600,
            "main": {
                "temp": 28.3,
                "feels_like": 32.52,
                "temp_min": 28.3,
                "temp_max": 28.3,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 78,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 5.61,
                "deg": 200,
                "gust": 9.45
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-04 18:00:00"
        },
        {
            "dt": 1688504400,
            "main": {
                "temp": 27.55,
                "feels_like": 31.26,
                "temp_min": 27.55,
                "temp_max": 27.55,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 988,
                "humidity": 82,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 6.01,
                "deg": 209,
                "gust": 10.06
            },
            "visibility": 10000,
            "pop": 0.09,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-04 21:00:00"
        },
        {
            "dt": 1688515200,
            "main": {
                "temp": 27.09,
                "feels_like": 30.35,
                "temp_min": 27.09,
                "temp_max": 27.09,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 988,
                "humidity": 84,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 5.48,
                "deg": 219,
                "gust": 9.21
            },
            "visibility": 10000,
            "pop": 0.01,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-05 00:00:00"
        },
        {
            "dt": 1688526000,
            "main": {
                "temp": 28.92,
                "feels_like": 33.11,
                "temp_min": 28.92,
                "temp_max": 28.92,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 73,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 803,
                    "main": "Clouds",
                    "description": "broken clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 75
            },
            "wind": {
                "speed": 6.06,
                "deg": 228,
                "gust": 7.36
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-05 03:00:00"
        },
        {
            "dt": 1688536800,
            "main": {
                "temp": 31.08,
                "feels_like": 35.02,
                "temp_min": 31.08,
                "temp_max": 31.08,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 60,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 87
            },
            "wind": {
                "speed": 5.3,
                "deg": 225,
                "gust": 6.17
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-05 06:00:00"
        },
        {
            "dt": 1688547600,
            "main": {
                "temp": 32.57,
                "feels_like": 36.27,
                "temp_min": 32.57,
                "temp_max": 32.57,
                "pressure": 999,
                "sea_level": 999,
                "grnd_level": 987,
                "humidity": 53,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 4.52,
                "deg": 217,
                "gust": 5.41
            },
            "visibility": 10000,
            "pop": 0.15,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-05 09:00:00"
        },
        {
            "dt": 1688558400,
            "main": {
                "temp": 33.3,
                "feels_like": 36.9,
                "temp_min": 33.3,
                "temp_max": 33.3,
                "pressure": 998,
                "sea_level": 998,
                "grnd_level": 986,
                "humidity": 50,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 4.84,
                "deg": 215,
                "gust": 5.12
            },
            "visibility": 10000,
            "pop": 0.15,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-05 12:00:00"
        },
        {
            "dt": 1688569200,
            "main": {
                "temp": 29.98,
                "feels_like": 33.84,
                "temp_min": 29.98,
                "temp_max": 29.98,
                "pressure": 999,
                "sea_level": 999,
                "grnd_level": 988,
                "humidity": 65,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 6.81,
                "deg": 215,
                "gust": 9.68
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-05 15:00:00"
        },
        {
            "dt": 1688580000,
            "main": {
                "temp": 28.15,
                "feels_like": 31.84,
                "temp_min": 28.15,
                "temp_max": 28.15,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 76,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 6.4,
                "deg": 201,
                "gust": 9.9
            },
            "visibility": 10000,
            "pop": 0.01,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-05 18:00:00"
        },
        {
            "dt": 1688590800,
            "main": {
                "temp": 27.35,
                "feels_like": 30.53,
                "temp_min": 27.35,
                "temp_max": 27.35,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 988,
                "humidity": 80,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 6,
                "deg": 210,
                "gust": 9.61
            },
            "visibility": 10000,
            "pop": 0.13,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-05 21:00:00"
        },
        {
            "dt": 1688601600,
            "main": {
                "temp": 26.88,
                "feels_like": 29.83,
                "temp_min": 26.88,
                "temp_max": 26.88,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 989,
                "humidity": 84,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 4.5,
                "deg": 206,
                "gust": 7.79
            },
            "visibility": 10000,
            "pop": 0.01,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-06 00:00:00"
        },
        {
            "dt": 1688612400,
            "main": {
                "temp": 27.52,
                "feels_like": 31.06,
                "temp_min": 27.52,
                "temp_max": 27.52,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 81,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 4.18,
                "deg": 204,
                "gust": 5.52
            },
            "visibility": 10000,
            "pop": 0.08,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-06 03:00:00"
        },
        {
            "dt": 1688623200,
            "main": {
                "temp": 30.73,
                "feels_like": 35.26,
                "temp_min": 30.73,
                "temp_max": 30.73,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 64,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 4.31,
                "deg": 214,
                "gust": 4.87
            },
            "visibility": 10000,
            "pop": 0.08,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-06 06:00:00"
        },
        {
            "dt": 1688634000,
            "main": {
                "temp": 32.96,
                "feels_like": 36.79,
                "temp_min": 32.96,
                "temp_max": 32.96,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 988,
                "humidity": 52,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 3.97,
                "deg": 251,
                "gust": 4.33
            },
            "visibility": 10000,
            "pop": 0.19,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-06 09:00:00"
        },
        {
            "dt": 1688644800,
            "main": {
                "temp": 32.6,
                "feels_like": 36.62,
                "temp_min": 32.6,
                "temp_max": 32.6,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 988,
                "humidity": 54,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 98
            },
            "wind": {
                "speed": 3.88,
                "deg": 213,
                "gust": 5.06
            },
            "visibility": 10000,
            "pop": 0.37,
            "rain": {
                "3h": 0.24
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-06 12:00:00"
        },
        {
            "dt": 1688655600,
            "main": {
                "temp": 29.88,
                "feels_like": 33.62,
                "temp_min": 29.88,
                "temp_max": 29.88,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 65,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10n"
                }
            ],
            "clouds": {
                "all": 98
            },
            "wind": {
                "speed": 6.06,
                "deg": 215,
                "gust": 8.61
            },
            "visibility": 10000,
            "pop": 0.39,
            "rain": {
                "3h": 0.23
            },
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-06 15:00:00"
        },
        {
            "dt": 1688666400,
            "main": {
                "temp": 27.72,
                "feels_like": 31.14,
                "temp_min": 27.72,
                "temp_max": 27.72,
                "pressure": 1003,
                "sea_level": 1003,
                "grnd_level": 991,
                "humidity": 78,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 803,
                    "main": "Clouds",
                    "description": "broken clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 68
            },
            "wind": {
                "speed": 6.12,
                "deg": 206,
                "gust": 9.43
            },
            "visibility": 10000,
            "pop": 0.51,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-06 18:00:00"
        },
        {
            "dt": 1688677200,
            "main": {
                "temp": 26.8,
                "feels_like": 29.64,
                "temp_min": 26.8,
                "temp_max": 26.8,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 84,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 95
            },
            "wind": {
                "speed": 5.42,
                "deg": 208,
                "gust": 9.05
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-06 21:00:00"
        },
        {
            "dt": 1688688000,
            "main": {
                "temp": 26.4,
                "feels_like": 26.4,
                "temp_min": 26.4,
                "temp_max": 26.4,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 86,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04n"
                }
            ],
            "clouds": {
                "all": 98
            },
            "wind": {
                "speed": 3.83,
                "deg": 207,
                "gust": 7.59
            },
            "visibility": 10000,
            "pop": 0,
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-07 00:00:00"
        },
        {
            "dt": 1688698800,
            "main": {
                "temp": 28.13,
                "feels_like": 31.95,
                "temp_min": 28.13,
                "temp_max": 28.13,
                "pressure": 1004,
                "sea_level": 1004,
                "grnd_level": 992,
                "humidity": 77,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 4.19,
                "deg": 212,
                "gust": 5
            },
            "visibility": 10000,
            "pop": 0.2,
            "rain": {
                "3h": 0.11
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-07 03:00:00"
        },
        {
            "dt": 1688709600,
            "main": {
                "temp": 29.65,
                "feels_like": 33.35,
                "temp_min": 29.65,
                "temp_max": 29.65,
                "pressure": 1003,
                "sea_level": 1003,
                "grnd_level": 991,
                "humidity": 66,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 2.69,
                "deg": 210,
                "gust": 3.68
            },
            "visibility": 10000,
            "pop": 0.27,
            "rain": {
                "3h": 0.11
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-07 06:00:00"
        },
        {
            "dt": 1688720400,
            "main": {
                "temp": 30.38,
                "feels_like": 34.02,
                "temp_min": 30.38,
                "temp_max": 30.38,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 62,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 2.74,
                "deg": 181,
                "gust": 3.56
            },
            "visibility": 10000,
            "pop": 0.35,
            "rain": {
                "3h": 0.16
            },
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-07 09:00:00"
        },
        {
            "dt": 1688731200,
            "main": {
                "temp": 29.15,
                "feels_like": 33.06,
                "temp_min": 29.15,
                "temp_max": 29.15,
                "pressure": 1000,
                "sea_level": 1000,
                "grnd_level": 988,
                "humidity": 70,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 804,
                    "main": "Clouds",
                    "description": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 2.41,
                "deg": 158,
                "gust": 4.58
            },
            "visibility": 10000,
            "pop": 0.32,
            "sys": {
                "pod": "d"
            },
            "dt_txt": "2023-07-07 12:00:00"
        },
        {
            "dt": 1688742000,
            "main": {
                "temp": 27.54,
                "feels_like": 30.85,
                "temp_min": 27.54,
                "temp_max": 27.54,
                "pressure": 1001,
                "sea_level": 1001,
                "grnd_level": 989,
                "humidity": 79,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 1.73,
                "deg": 203,
                "gust": 3.77
            },
            "visibility": 10000,
            "pop": 0.83,
            "rain": {
                "3h": 1.39
            },
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-07 15:00:00"
        },
        {
            "dt": 1688752800,
            "main": {
                "temp": 26.64,
                "feels_like": 26.64,
                "temp_min": 26.64,
                "temp_max": 26.64,
                "pressure": 1002,
                "sea_level": 1002,
                "grnd_level": 990,
                "humidity": 85,
                "temp_kf": 0
            },
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10n"
                }
            ],
            "clouds": {
                "all": 100
            },
            "wind": {
                "speed": 2.58,
                "deg": 200,
                "gust": 5.9
            },
            "visibility": 10000,
            "pop": 0.92,
            "rain": {
                "3h": 0.97
            },
            "sys": {
                "pod": "n"
            },
            "dt_txt": "2023-07-07 18:00:00"
        }
    ],
    "city": {
        "name": "cityName",
        "country": "IN",
        "timezone": 19800,
        "sunrise": 1688343935,
        "sunset": 1688392473
    }
}
''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          await weatherRepository.fetchWeatherForecast(location: const LatLng(22.5046, 73.4714)),
          isRightThat(
            isA<List<Weather>>().having((weatherList) => weatherList[0].cityName, 'cityName', 'cityName'),
          ),
        );
      });
    });
  });
}
