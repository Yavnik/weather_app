part of 'map_screen_bloc.dart';

@freezed
class MapScreenEvent with _$MapScreenEvent {
  const factory MapScreenEvent.fetchTileOverlay({required String layerName}) = _FetchTileOverlay;
}
