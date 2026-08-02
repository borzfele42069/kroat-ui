import 'package:flutter_test/flutter_test.dart';
import 'package:kroat_ui/services/word_service.dart';

void main() {
  group('WordService', () {
    test('nextIndex wraps around at end', () {
      expect(WordService.nextIndex(7, 8), equals(0));
    });

    test('nextIndex increments normally', () {
      expect(WordService.nextIndex(0, 8), equals(1));
      expect(WordService.nextIndex(3, 8), equals(4));
    });

    test('prevIndex wraps around at start', () {
      expect(WordService.prevIndex(0, 8), equals(7));
    });

    test('prevIndex decrements normally', () {
      expect(WordService.prevIndex(7, 8), equals(6));
      expect(WordService.prevIndex(3, 8), equals(2));
    });
  });
}
