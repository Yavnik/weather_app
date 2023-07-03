import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/application/weather/weather_bloc.dart';
import 'package:weather_app/infrastructure/weather/weather_repository.dart';
import 'package:weather_app/presentation/core/colors.dart';
import 'package:weather_app/presentation/weather_screen/weather_screen_widget.dart';

class WeatherScreen extends StatelessWidget {
  final LatLng location;
  const WeatherScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(location, WeatherRepository())..add(const WeatherEvent.fetchWeather()),
      child: Scaffold(
        backgroundColor: ColorPallete.primaryBackground,
        body: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            // TODO: Show snackbars based on error state.
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WeatherBloc>().add(const WeatherEvent.fetchWeather());
              },
              child: state.map(
                loading: (value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(value.message),
                      ],
                    ),
                  );
                },
                error: (value) {
                  return const Center(child: Icon(Icons.error)); // TODO: Add error description
                },
                weatherFetched: (value) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: WeatherScreenWidget(
                      weather: value.weather,
                      hourlyForecast: value.hourlyForecast,
                      timeFrameIndex: value.timeFrameIndex,
                      tomorrowForecast: value.tomorrowForecast,
                      totalForecast: value.totalForecast,
                      location: location,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
