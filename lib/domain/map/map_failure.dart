import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_failure.freezed.dart';

@freezed
abstract class MapFailure with _$MapFailure {
  const factory MapFailure.unexpected() = _Unexpected;
  const factory MapFailure.noInternet() = _NoInternet;
  const factory MapFailure.serverError() = _ServerError;
}
