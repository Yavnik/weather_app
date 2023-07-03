import 'package:freezed_annotation/freezed_annotation.dart';
part 'location_failure.freezed.dart';

@freezed
abstract class LocationFailure with _$LocationFailure {
  const factory LocationFailure.deniedForeground() = _DeniedForeground;
  const factory LocationFailure.serviceNotEnabled() = _ServiceNotEnabled;
}
