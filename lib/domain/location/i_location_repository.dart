import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_failure.dart';

abstract class ILocationRepository {
  Future<Either<LocationFailure, LatLng>> getLocation();
}
