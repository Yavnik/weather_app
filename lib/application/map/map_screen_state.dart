part of 'map_screen_bloc.dart';

@freezed
class MapScreenState with _$MapScreenState {
  const factory MapScreenState.initial() = _Initial;
  const factory MapScreenState.tileOverlay({required TileOverlay tileOverlay, required String currentLayer}) = _TileOverlay;
}
