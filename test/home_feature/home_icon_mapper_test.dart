import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/feature/home_feature/domain/entities/home_icon_key.dart';
import 'package:portfolio/feature/home_feature/presentation/mappers/home_icon_mapper.dart';

void main() {
  test('every home icon key maps to an icon', () {
    for (final key in HomeIconKey.values) {
      expect(key.icon.codePoint, isPositive);
      expect(key.icon.fontFamily, isNotEmpty);
    }
  });
}
