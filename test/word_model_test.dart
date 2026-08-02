import 'package:flutter_test/flutter_test.dart';
import 'package:kroat_ui/models/word.dart';

void main() {
  group('Word Model', () {
    test('word initializes with default values', () {
      final word = Word(croatian: 'Test', hungarian: 'Teszt');
      expect(word.croatian, equals('Test'));
      expect(word.hungarian, equals('Teszt'));
      expect(word.status, equals(WordStatus.unknown));
      expect(word.streakCount, equals(0));
      expect(word.quotient, equals(1.0));
      expect(word.lastReviewedAt, isNull);
    });

    test('word initializes with custom values', () {
      final now = DateTime.now();
      final word = Word(
        croatian: 'Test',
        hungarian: 'Teszt',
        status: WordStatus.learned,
        streakCount: 5,
        quotient: 2.5,
        lastReviewedAt: now,
      );
      expect(word.status, equals(WordStatus.learned));
      expect(word.streakCount, equals(5));
      expect(word.quotient, equals(2.5));
      expect(word.lastReviewedAt, equals(now));
    });

    test('word serializes to JSON', () {
      final word = Word(
        croatian: 'Test',
        hungarian: 'Teszt',
        status: WordStatus.learned,
        streakCount: 3,
        quotient: 1.5,
      );
      final json = word.toJson();

      expect(json['croatian'], equals('Test'));
      expect(json['hungarian'], equals('Teszt'));
      expect(json['status'], equals('WordStatus.learned'));
      expect(json['streakCount'], equals(3));
      expect(json['quotient'], equals(1.5));
    });

    test('word deserializes from JSON', () {
      final json = {
        'croatian': 'Test',
        'hungarian': 'Teszt',
        'status': 'WordStatus.inProgress',
        'streakCount': 2,
        'quotient': 1.2,
        'lastReviewedAt': null,
      };
      final word = Word.fromJson(json);

      expect(word.croatian, equals('Test'));
      expect(word.hungarian, equals('Teszt'));
      expect(word.status, equals(WordStatus.inProgress));
      expect(word.streakCount, equals(2));
      expect(word.quotient, equals(1.2));
    });

    test('word deserializes with unknown status defaults to unknown', () {
      final json = {
        'croatian': 'Test',
        'hungarian': 'Teszt',
        'status': 'WordStatus.unknown',
        'streakCount': 0,
        'quotient': 1.0,
        'lastReviewedAt': null,
      };
      final word = Word.fromJson(json);
      expect(word.status, equals(WordStatus.unknown));
    });

    test('word roundtrips through JSON serialization', () {
      final original = Word(
        croatian: 'Zdravo',
        hungarian: 'Szia',
        status: WordStatus.learned,
        streakCount: 7,
        quotient: 0.8,
      );

      final json = original.toJson();
      final restored = Word.fromJson(json);

      expect(restored.croatian, equals(original.croatian));
      expect(restored.hungarian, equals(original.hungarian));
      expect(restored.status, equals(original.status));
      expect(restored.streakCount, equals(original.streakCount));
      expect(restored.quotient, equals(original.quotient));
    });
  });
}
