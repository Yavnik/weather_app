import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:weather_app/domain/location/i_location_repository.dart';
import 'package:weather_app/domain/location/location_failure.dart';

class LocationRepository implements ILocationRepository {
  @override
  Future<Either<LocationFailure, LatLng>> getLocation() async {
    final Location location = Location();

    try {
      final locationData = await location.getLocation();
      return right(LatLng(locationData.latitude!, locationData.longitude!));
    } catch (_) {
      return left(const LocationFailure.serviceNotEnabled());
    }
  }
}
