/// DTO or Data Transfer Object helps in converting raw String recieved from aaplication
/// layer to OpenWeatherMap API specific Strings.
///
/// DTOs are important as we should not keep OpenWeatherMap API specific logic in domain layer
/// Domain layer must be data source agnostic. If tomorrow we change our data source that
/// requires different arguments, any other layer must not be affected by that change.

abstract class MapDTO {
  static String layerNameFromDomain({required String layerName}) {
    String openWeatherLayerName;
    switch (layerName) {
      case 'temperature':
        openWeatherLayerName = 'temp_new';
        break;
      case 'pressure':
        openWeatherLayerName = 'pressure_new';
        break;
      case 'wind':
        openWeatherLayerName = 'wind_new';
        break;
      case 'precipitation':
        openWeatherLayerName = 'precipitation_new';
        break;
      case 'clouds':
        openWeatherLayerName = 'clouds_new';
        break;
      default:
        openWeatherLayerName = 'temp_new';
        break;
    }
    return openWeatherLayerName;
  }
}
