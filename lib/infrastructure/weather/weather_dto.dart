import 'package:weather_app/domain/weather/weather.dart';

/// DTO or Data Transfer Object helps in converting raw json recieved from data source
/// to Objects defined in the domain.
/// Here, the raw json recieved from OpenWeatherMap API is converted to [Weather] objects
///
/// DTOs are important as we should not keep JSON to [Weather] conversion logic
/// that is OpenWeatherMap API specific in domain layer
/// Domain layer must be data source agnostic. If tomorrow we change our data source that
/// sends different key value pairs or other format like xml, any other layer must not be
/// affected by that change.

abstract class WeatherDTO {
  static Weather toWeatherDomain(Map<String, dynamic> json) {
    return Weather(
      weatherTitle: json['weather'][0]['main'] ?? '',
      weatherDescription: json['weather'][0]['description'],
      weatherIconUrl: getIconUrl(json['weather'][0]['icon']),
      temperature: double.parse('${json['main']['temp']}'),
      feelsLike: double.parse('${json['main']['feels_like']}'),
      pressure: double.parse('${json['main']['pressure']}'),
      humidity: double.parse('${json['main']['humidity']}'),
      tempLow: double.parse('${json['main']['temp_min']}'),
      tempHigh: double.parse('${json['main']['temp_max']}'),
      visibility: double.parse('${json['visibility']}'),
      windSpeed: double.parse('${json['wind']['speed']}'),
      precipitationProbability: 0,
      cloudiness: double.parse('${json['clouds']['all']}'),
      timeOfData: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      sunriseTime: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunsetTime: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      cityName: json['name'],
    );
  }

  static List<Weather> toForecastDomain(Map<String, dynamic> json) {
    return List.from(
      (json['list'] as Iterable).map(
        (weather) => Weather(
          weatherTitle: weather['weather'][0]['main'] ?? '',
          weatherDescription: weather['weather'][0]['description'],
          weatherIconUrl: getIconUrl(weather['weather'][0]['icon']),
          temperature: double.parse('${weather['main']['temp']}'),
          feelsLike: double.parse('${weather['main']['feels_like']}'),
          pressure: double.parse('${weather['main']['pressure']}'),
          humidity: double.parse('${weather['main']['humidity']}'),
          tempLow: double.parse('${weather['main']['temp_min']}'),
          tempHigh: double.parse('${weather['main']['temp_max']}'),
          visibility: double.parse('${weather['visibility']}'),
          windSpeed: double.parse('${weather['wind']['speed']}'),
          precipitationProbability: double.parse('${weather['pop'] ?? 0}'),
          cloudiness: double.parse('${weather['clouds']['all']}'),
          timeOfData: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          sunriseTime: DateTime.fromMillisecondsSinceEpoch(json['city']['sunrise'] * 1000),
          sunsetTime: DateTime.fromMillisecondsSinceEpoch(json['city']['sunset'] * 1000),
          cityName: json['city']['name'],
        ),
      ),
    );
  }

  static String getIconUrl(String id) => 'https://openweathermap.org/img/wn/$id@4x.png';
}
