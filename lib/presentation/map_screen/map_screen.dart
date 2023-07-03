import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/application/map/map_screen_bloc.dart';
import 'package:weather_app/domain/map/layer_name.dart';
import 'package:weather_app/domain/weather/weather.dart';
import 'package:weather_app/infrastructure/map/map_repository.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:weather_app/presentation/core/colors.dart';

class MapScreen extends StatelessWidget {
  final LatLng location;
  final Weather weather;
  const MapScreen({super.key, required this.location, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
        centerTitle: true,
        backgroundColor: ColorPallete.primary80,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => MapScreenBloc(MapRepository()),
        child: BlocConsumer<MapScreenBloc, MapScreenState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: location, zoom: 4),
                  myLocationEnabled: false,
                  markers: {
                    Marker(
                      markerId: const MarkerId('location'),
                      infoWindow: InfoWindow(title: 'Weather', snippet: 'Temperature: ${weather.temperature.round()}°'),
                      position: location,
                      visible: true,
                    )
                  },
                  onMapCreated: (controller) async {
                    context.read<MapScreenBloc>().add(MapScreenEvent.fetchTileOverlay(layerName: LayerName.temperature.name));
                    final String mapStyle = await rootBundle.loadString('assets/map_style.txt');
                    await controller.setMapStyle(mapStyle);
                    controller.showMarkerInfoWindow(const MarkerId('location'));
                  },
                  tileOverlays: state.map(
                    initial: (_) {
                      return {};
                    },
                    tileOverlay: (value) {
                      return <TileOverlay>{value.tileOverlay};
                    },
                  ),
                ),
                state.map(
                  initial: (_) => Container(),
                  tileOverlay: (value) => Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [BoxShadow(blurRadius: 1, spreadRadius: 2, color: ColorPallete.primaryBackground)]),
                      padding: const EdgeInsets.all(5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              context.read<MapScreenBloc>().add(MapScreenEvent.fetchTileOverlay(layerName: LayerName.values[index].name));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: value.currentLayer == LayerName.values[index].name ? ColorPallete.primary80 : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                LayerName.values[index].name.toUpperCase(),
                                style: TextStyle(color: value.currentLayer == LayerName.values[index].name ? Colors.white : Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
