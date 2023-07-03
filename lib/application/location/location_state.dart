part of 'location_bloc.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState.loading({required String message}) = _Loading;
  const factory LocationState.error() = _Error;
  const factory LocationState.permissionGranted({required LatLng location}) = _PermissionGranted;
  const factory LocationState.permissionNotGranted({required PermissionStatus status}) = _PermissionNotGranted;
}
