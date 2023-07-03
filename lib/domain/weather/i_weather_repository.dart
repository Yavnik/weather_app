import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/domain/weather/weather_failure.dart';

abstract class IWeatherRepository {
  Future<Either<WeatherFailure, Weather>> fetchWeather({required LatLng location});
  Future<Either<WeatherFailure, List<Weather>>> fetchWeatherForecast({required LatLng location});
}
