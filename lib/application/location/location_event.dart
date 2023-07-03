part of 'location_bloc.dart';

@freezed
class LocationEvent with _$LocationEvent {
  const factory LocationEvent.getPermission({required PermissionStatus status}) = _GetPermission;
  const factory LocationEvent.checkPermission() = _CheckPermission;
}
