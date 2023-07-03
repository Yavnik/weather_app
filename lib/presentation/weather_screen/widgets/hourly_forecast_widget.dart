import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/presentation/core/colors.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<Weather> forecast;
  const HourlyForecastWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPallete.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                radius: 16,
                child: Icon(Icons.av_timer, size: 16),
              ),
              SizedBox(width: 10),
              Text(
                'Hourly Forecast',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.from(
              forecast.map(
                (weather) => Column(
                  children: [
                    Text(DateFormat('h a').format(weather.timeOfData.toLocal())),
                    CachedNetworkImage(imageUrl: weather.weatherIconUrl, height: 50),
                    Text('${weather.temperature.round()}°')
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
