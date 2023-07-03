import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/domain/map/i_map_repository.dart';

part 'map_screen_event.dart';
part 'map_screen_state.dart';
part 'map_screen_bloc.freezed.dart';

/// On [MapScreenEvent.fetchTileOverlay()], fetch TileOverlay from [MapRepository] and return in state.

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  final IMapRepository _mapRepository;
  MapScreenBloc(this._mapRepository) : super(const MapScreenState.initial()) {
    on<MapScreenEvent>((event, emit) async {
      await event.map(
        fetchTileOverlay: (value) async {
          final res = await _mapRepository.fetchTileOverlay(value.layerName);

          /// [res] is of typee [Either<MapFailure,TileOverlay>]
          /// Fold [res] value and emit result based on [isLeft] or [isRight]
          res.fold(
            //TODO: emit error state on [MapFailure] so UI can display error snackbar to user
            (l) => null,
            (tileOverlay) {
              emit(MapScreenState.tileOverlay(tileOverlay: tileOverlay, currentLayer: value.layerName));
            },
          );
        },
      );
    });
  }
}
