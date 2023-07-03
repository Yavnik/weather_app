import 'package:flutter/material.dart';
import 'package:weather_app/domain/weather/weather.dart';

import 'forecast_details_widget.dart';

class FiveDaysWeatherWidget extends StatelessWidget {
  final List<Weather> forecast;
  const FiveDaysWeatherWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: forecast.length,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ForecastDetailsWidget(weather: forecast[index]);
      },
    );
  }
}
