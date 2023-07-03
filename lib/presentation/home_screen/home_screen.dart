import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/location/location_bloc.dart';
import 'package:weather_app/infrastructure/location/location_repository.dart';
import 'package:weather_app/presentation/core/colors.dart';
import 'package:weather_app/presentation/weather_screen/weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(LocationRepository())..add(const LocationEvent.checkPermission()),
      child: Scaffold(
        backgroundColor: ColorPallete.primaryBackground,
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            state.mapOrNull(
              error: (value) {
                context.read<LocationBloc>().add(const LocationEvent.checkPermission());
              },
            );
          },
          builder: (context, state) {
            return state.map(
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
                return const Center(child: Icon(Icons.error));
              },
              permissionNotGranted: (value) {
                return AlertDialog(
                  title: const Text('Give location permission'),
                  content: const Text('This app needs Location Permission to display Weather of your area'),
                  icon: const Icon(Icons.location_on),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        //TODO: Show snackbar that says can't work without Location Permission
                      },
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LocationBloc>().add(LocationEvent.getPermission(status: value.status));
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
              permissionGranted: (value) {
                return WeatherScreen(location: value.location);
              },
            );
          },
        ),
      ),
    );
  }
}
