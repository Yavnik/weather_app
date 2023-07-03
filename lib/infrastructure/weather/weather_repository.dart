import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/domain/weather/i_weather_repository.dart';
import 'package:weather_app/domain/weather/weather_failure.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/infrastructure/weather/weather_dto.dart';

class WeatherRepository implements IWeatherRepository {
  WeatherRepository({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();
  final http.Client _httpClient;

  @override
  Future<Either<WeatherFailure, Weather>> fetchWeather({required LatLng location}) async {
    try {
      final String appid = FlutterConfig.get('OPEN_WEATHER_MAP_API_KEY').toString();
      final Uri uri = Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: 'data/2.5/weather',
        queryParameters: {
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'units': 'metric',
          'appid': appid,
        },
      );
      final res = await _httpClient.get(uri);
      if (res.statusCode == 200) {
        return right(WeatherDTO.toWeatherDomain(jsonDecode(res.body))); // returns [Weather] object after passing recieved data through DTO
      } else {
        return left(const WeatherFailure.serverError());
      }
    } catch (_) {
      return left(const WeatherFailure.unexpected());
    }
  }

  @override
  Future<Either<WeatherFailure, List<Weather>>> fetchWeatherForecast({required LatLng location}) async {
    try {
      final String appid = FlutterConfig.get('OPEN_WEATHER_MAP_API_KEY').toString();
      final Uri uri = Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: 'data/2.5/forecast',
        queryParameters: {
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'units': 'metric',
          'appid': appid,
        },
      );
      final res = await _httpClient.get(uri);
      if (res.statusCode == 200) {
        return right(WeatherDTO.toForecastDomain(jsonDecode(res.body)));
      } else {
        return left(const WeatherFailure.serverError());
      }
    } catch (_) {
      return left(const WeatherFailure.unexpected());
    }
  }
}
