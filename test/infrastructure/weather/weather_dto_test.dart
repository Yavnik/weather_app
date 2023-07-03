import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/infrastructure/weather/weather_dto.dart';

void main() {
  group('WeatherDTO', () {
    test('toWeatherDomain returns correct instance of Weather class', () {
      final json = {
        "weather": [
          {"id": 804, "main": "Clouds", "description": "overcast clouds", "icon": "04n"}
        ],
        "base": "stations",
        "main": {
          "temp": 28.04,
          "feels_like": 32.2,
          "temp_min": 28.04,
          "temp_max": 28.04,
          "pressure": 1004,
          "humidity": 80,
          "sea_level": 1004,
          "grnd_level": 992
        },
        "visibility": 10000,
        "wind": {"speed": 4.26, "deg": 205, "gust": 9},
        "clouds": {"all": 100},
        "dt": 1688324757,
        "sys": {"country": "IN", "sunrise": 1688343935, "sunset": 1688392473},
        "timezone": 19800,
        "name": "cityName",
        "cod": 200
      };
      expect(
        WeatherDTO.toWeatherDomain(json),
        isA<Weather>()
            .having((weather) => weather.cityName, 'cityName', 'cityName')
            .having((weather) => weather.temperature, 'temperature', 28.04)
            .having((weather) => weather.visibility, 'visibility', 10000),
      );
    });
  });
}
