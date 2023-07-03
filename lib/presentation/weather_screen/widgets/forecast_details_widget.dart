import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/presentation/core/colors.dart';
import 'package:weather_app/presentation/core/extensions.dart';

class ForecastDetailsWidget extends StatelessWidget {
  final Weather weather;
  const ForecastDetailsWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: ColorPallete.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMM dd, h a').format(weather.timeOfData.toLocal()),
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  weather.weatherDescription.capitalize(),
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(fontSize: 16),
          ),
          CachedNetworkImage(imageUrl: weather.weatherIconUrl),
        ],
      ),
    );
  }
}
