import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/weather/weather.dart';

void main() {
  group('Weather', () {
    test('returns proper Weather object', () {
      expect(
          Weather(
            weatherTitle: 'weatherTitle',
            weatherDescription: 'weatherDescription',
            weatherIconUrl: 'weatherIconUrl',
            temperature: 9.1,
            feelsLike: 9.2,
            pressure: 9.3,
            humidity: 9.4,
            tempLow: 9.5,
            tempHigh: 9.6,
            visibility: 9.7,
            windSpeed: 9.8,
            precipitationProbability: 9.9,
            cloudiness: 10.0,
            timeOfData: DateTime(2000),
            sunriseTime: DateTime(2001),
            sunsetTime: DateTime(2002),
            cityName: 'cityName',
          ),
          isA<Weather>()
              .having((weather) => weather.weatherTitle, 'weatherTitle', 'weatherTitle')
              .having((weather) => weather.temperature, 'temperature', 9.1)
              .having((weather) => weather.visibility, 'visibilty', 9.7)
              .having((weather) => weather.timeOfData, 'timeOfData', DateTime(2000)));
    });
  });
}
