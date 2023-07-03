import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/infrastructure/map/map_dto.dart';

void main() {
  group('MapDTO', () {
    test('layerNameFromDomain returns correct String layerName temperature', () {
      expect(
        MapDTO.layerNameFromDomain(layerName: 'temperature'),
        isA<String>().having((value) => value, 'layerName', 'temp_new'),
      );
    });

    test('layerNameFromDomain returns correct String layerName pressure', () {
      expect(
        MapDTO.layerNameFromDomain(layerName: 'pressure'),
        isA<String>().having((value) => value, 'layerName', 'pressure_new'),
      );
    });

    test('layerNameFromDomain returns correct String layerName when given false String', () {
      expect(
        MapDTO.layerNameFromDomain(layerName: 'THISSHOULDRETURNTEMPERATURE'),
        isA<String>().having((value) => value, 'layerName', 'temp_new'),
      );
    });
    test('layerNameFromDomain returns correct String layerName when given blank String', () {
      expect(
        MapDTO.layerNameFromDomain(layerName: ''),
        isA<String>().having((value) => value, 'layerName', 'temp_new'),
      );
    });
  });
}
