import 'package:flutter/material.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/presentation/weather_screen/widgets/forecast_chart_widget.dart';
import 'package:weather_app/presentation/weather_screen/widgets/forecast_details_widget.dart';

class TomorrowWeatherWidget extends StatelessWidget {
  final List<Weather> tomorrowForecast;
  const TomorrowWeatherWidget({super.key, required this.tomorrowForecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ForecastChartWidget(forecaseList: tomorrowForecast, tomorrowForecast: true),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: tomorrowForecast.length,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ForecastDetailsWidget(weather: tomorrowForecast[index]);
          },
        ),
      ],
    );
  }
}
