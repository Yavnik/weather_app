import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/domain/map/map_failure.dart';

abstract class IMapRepository {
  Future<Either<MapFailure, TileOverlay>> fetchTileOverlay(String layerName);
}
