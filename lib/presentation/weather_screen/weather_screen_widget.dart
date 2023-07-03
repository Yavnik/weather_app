import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/application/weather/weather_bloc.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/presentation/core/colors.dart';
import 'package:weather_app/presentation/core/dimensions.dart';
import 'package:weather_app/presentation/core/extensions.dart';
import 'package:weather_app/presentation/weather_screen/widgets/five_days_weather_widget.dart';
import 'package:weather_app/presentation/weather_screen/widgets/today_weather_widget.dart';
import 'package:weather_app/presentation/weather_screen/widgets/tomorrow_weather_widget.dart';

class WeatherScreenWidget extends StatelessWidget {
  final Weather weather;
  final LatLng location;
  final List<Weather> hourlyForecast;
  final List<Weather> tomorrowForecast;
  final List<Weather> totalForecast;
  final int timeFrameIndex;
  const WeatherScreenWidget({
    super.key,
    required this.weather,
    required this.hourlyForecast,
    required this.timeFrameIndex,
    required this.tomorrowForecast,
    required this.totalForecast,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 390,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/background_image.jpg',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + Dimensions.padding.top,
                left: Dimensions.padding.left,
                right: Dimensions.padding.right,
                bottom: Dimensions.padding.bottom,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature.round()}°',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 112,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Feels like ${weather.feelsLike.round()}°',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImage(imageUrl: weather.weatherIconUrl, height: 140),
                            Text(
                              weather.weatherDescription.capitalize(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('MMMM d, HH:mm').format(weather.timeOfData),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: Dimensions.padding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<WeatherBloc>().add(const WeatherEvent.changeTimeFrame(timeFrameIndex: 0));
                    },
                    child: Container(
                      width: 116,
                      height: 42,
                      decoration: ShapeDecoration(
                        color: timeFrameIndex == 0 ? ColorPallete.primary80 : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Today',
                          style: TextStyle(
                            color: timeFrameIndex == 0 ? ColorPallete.onPrimary80 : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<WeatherBloc>().add(const WeatherEvent.changeTimeFrame(timeFrameIndex: 1));
                    },
                    child: Container(
                      width: 116,
                      height: 42,
                      decoration: ShapeDecoration(
                        color: timeFrameIndex == 1 ? ColorPallete.primary80 : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Tomorrow',
                          style: TextStyle(
                            color: timeFrameIndex == 1 ? ColorPallete.onPrimary80 : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<WeatherBloc>().add(const WeatherEvent.changeTimeFrame(timeFrameIndex: 2));
                    },
                    child: Container(
                      width: 116,
                      height: 42,
                      decoration: ShapeDecoration(
                        color: timeFrameIndex == 2 ? ColorPallete.primary80 : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '5 days',
                          style: TextStyle(
                            color: timeFrameIndex == 0 ? ColorPallete.onPrimary80 : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              getDisplay(timeFrameIndex),
            ],
          ),
        ),
      ],
    );
  }

  Widget getDisplay(int timeFrameIndex) {
    switch (timeFrameIndex) {
      case 0:
        return TodayWeatherWidget(weather: weather, forecast: hourlyForecast, location: location);
      case 1:
        return TomorrowWeatherWidget(tomorrowForecast: tomorrowForecast);
      case 2:
        return FiveDaysWeatherWidget(forecast: totalForecast);
      default:
        return TodayWeatherWidget(weather: weather, forecast: hourlyForecast, location: location);
    }
  }
}
