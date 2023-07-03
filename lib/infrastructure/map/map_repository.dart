import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:weather_app/domain/map/i_map_repository.dart';
import 'package:weather_app/domain/map/map_failure.dart';
import 'package:weather_app/infrastructure/map/map_dto.dart';

class TileProviderRepository implements TileProvider {
  final String layerName;
  Uint8List tileBytes = Uint8List(0);
  int tileSize = 256;
  TileProviderRepository({
    required this.layerName,
  });

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final String appid = FlutterConfig.get('OPEN_WEATHER_MAP_API_KEY').toString();
    final Uri uri = Uri(
      scheme: 'https',
      host: 'tile.openweathermap.org',
      path: 'map/$layerName/$zoom/$x/$y.png',
      queryParameters: {'appid': appid},
    );
    final ByteData imageData = await NetworkAssetBundle(uri).load('');
    tileBytes = imageData.buffer.asUint8List();
    return Tile(tileSize, tileSize, tileBytes);
  }
}

class MapRepository implements IMapRepository {
  @override
  Future<Either<MapFailure, TileOverlay>> fetchTileOverlay(String layerName) async {
    try {
      TileOverlay tileOverlay = TileOverlay(
        tileOverlayId: TileOverlayId(DateTime.now().toString()),
        tileProvider: TileProviderRepository(layerName: MapDTO.layerNameFromDomain(layerName: layerName)),
      );
      return right(tileOverlay);
    } catch (_) {
      return left(const MapFailure.serverError());
    }
  }
}
