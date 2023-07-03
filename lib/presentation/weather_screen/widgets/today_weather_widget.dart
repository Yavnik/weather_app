import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/presentation/core/colors.dart';
import 'package:weather_app/presentation/map_screen/map_screen.dart';

import 'forecast_chart_widget.dart';
import 'hourly_forecast_widget.dart';
import 'single_details_widget.dart';

class TodayWeatherWidget extends StatelessWidget {
  final Weather weather;
  final LatLng location;
  final List<Weather> forecast;
  const TodayWeatherWidget({super.key, required this.weather, required this.forecast, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MapScreen(weather: weather, location: location),
            ));
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: ColorPallete.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CircleAvatar(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.map),
                ),
                Text(
                  'View on Map',
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Flexible(
              child: SingleDetailsWidget(
                title: 'Humidity',
                value: '${weather.humidity.round()}%',
                iconData: Icons.water_drop_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: SingleDetailsWidget(
                title: 'Pressure',
                value: '${weather.pressure.round()} hPa',
                iconData: Icons.water,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Flexible(
              child: SingleDetailsWidget(
                title: 'Wind Speed',
                value: '${(weather.windSpeed * 18 / 5).round()} km/h',
                iconData: Icons.air,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: SingleDetailsWidget(
                title: 'Cloudiness',
                value: '${weather.cloudiness.round()}%',
                iconData: Icons.cloud_queue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ForecastChartWidget(forecaseList: forecast, tomorrowForecast: false),
        const SizedBox(height: 16),
        HourlyForecastWidget(forecast: forecast),
        const SizedBox(height: 16),
        Row(
          children: [
            Flexible(
              child: SingleDetailsWidget(
                title: 'Sunrise',
                value: DateFormat('h:mm a').format(weather.sunriseTime),
                iconData: Icons.wb_sunny_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: SingleDetailsWidget(
                title: 'Sunset',
                value: DateFormat('h:mm a').format(weather.sunsetTime),
                iconData: Icons.sunny_snowing,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
