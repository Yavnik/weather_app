import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/domain/location/i_location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';
part 'location_bloc.freezed.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final ILocationRepository _locationRepository;
  LocationBloc(this._locationRepository) : super(const LocationState.loading(message: 'Fetching location...')) {
    on<LocationEvent>(
      (event, emit) async {
        await event.map(
          checkPermission: (_) async {
            final status = await Permission.location.status;
            if (status.isGranted) {
              emit(const LocationState.loading(message: 'Fetching location...'));
              final location = await _locationRepository.getLocation();
              location.fold(
                (failure) {
                  emit(const LocationState.error());
                },
                (location) {
                  log('Go location');
                  emit(LocationState.permissionGranted(location: location));
                },
              );
              return;
            } else {
              emit(LocationState.permissionNotGranted(status: status));
            }
          },
          getPermission: (value) async {
            if (value.status.isDenied) {
              emit(const LocationState.loading(message: 'Fetching location...'));
              final statusNew = await Permission.location.request();
              if (statusNew.isPermanentlyDenied) {
                await openAppSettings();
              }
              add(const LocationEvent.checkPermission());
              return;
            }
          },
        );
      },
    );
  }
}
