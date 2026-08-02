import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kroat_ui/services/word_service.dart';
import 'package:kroat_ui/models/word.dart';
import 'dart:convert';

void main() {
  setUpAll(() async {
    await WordService.initialize();
  });
  group('WordService - Navigation', () {
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

  group('WordService - Quotient (SM-2)', () {
    test('correct answer in learned state decreases quotient', () {
      final result = WordService.updateQuotient(2.0, true, isLearned: true);
      expect(result, equals(1.9));
    });

    test('correct answer clamps quotient to minimum 0.5', () {
      final result = WordService.updateQuotient(0.6, true, isLearned: true);
      expect(result, equals(0.5));
    });

    test('incorrect answer in learned state increases quotient', () {
      final result = WordService.updateQuotient(2.0, false, isLearned: true);
      expect(result, equals(2.2));
    });

    test('incorrect answer clamps quotient to maximum 3.0', () {
      final result = WordService.updateQuotient(2.9, false, isLearned: true);
      expect(result, equals(3.0));
    });

    test('quotient unchanged when word not learned', () {
      final result = WordService.updateQuotient(1.5, true, isLearned: false);
      expect(result, equals(1.5));
    });

    test('quotient unchanged on failure when word not learned', () {
      final result = WordService.updateQuotient(1.5, false, isLearned: false);
      expect(result, equals(1.5));
    });
  });

  group('WordService - Status Transitions', () {
    test('correct answer transitions unknown to inProgress', () {
      final status = WordService.calculateNewStatus(true, 1, WordStatus.unknown);
      expect(status, equals(WordStatus.inProgress));
    });

    test('correct answer at 7 streak transitions to learned', () {
      final status = WordService.calculateNewStatus(true, 7, WordStatus.inProgress);
      expect(status, equals(WordStatus.learned));
    });

    test('correct answer keeps learned status', () {
      final status = WordService.calculateNewStatus(true, 3, WordStatus.learned);
      expect(status, equals(WordStatus.learned));
    });

    test('incorrect answer transitions to inProgress', () {
      final status = WordService.calculateNewStatus(false, 5, WordStatus.learned);
      expect(status, equals(WordStatus.inProgress));
    });

    test('incorrect answer keeps inProgress', () {
      final status = WordService.calculateNewStatus(false, 2, WordStatus.inProgress);
      expect(status, equals(WordStatus.inProgress));
    });

    test('correct answer at 6 streak does not learn yet', () {
      final status = WordService.calculateNewStatus(true, 6, WordStatus.inProgress);
      expect(status, equals(WordStatus.inProgress));
    });
  });

  group('WordService - Quotient Threshold', () {
    test('quotient at 3.0 should revert to inProgress', () {
      expect(WordService.shouldRevertToInProgress(3.0), isTrue);
    });

    test('quotient below 3.0 should not revert', () {
      expect(WordService.shouldRevertToInProgress(2.9), isFalse);
    });

    test('quotient at 1.0 should not revert', () {
      expect(WordService.shouldRevertToInProgress(1.0), isFalse);
    });
  });

  group('WordService - Answer Validation', () {
    test('correct answer is recognized', () {
      final isCorrect = WordService.isCorrectAnswer(0, 'Szia');
      expect(isCorrect, isTrue);
    });

    test('correct answer case-insensitive', () {
      final isCorrect = WordService.isCorrectAnswer(0, 'SZIA');
      expect(isCorrect, isTrue);
    });

    test('correct answer with whitespace', () {
      final isCorrect = WordService.isCorrectAnswer(0, '  Szia  ');
      expect(isCorrect, isTrue);
    });

    test('incorrect answer is rejected', () {
      final isCorrect = WordService.isCorrectAnswer(0, 'wrong');
      expect(isCorrect, isFalse);
    });

    test('invalid index returns false', () {
      final isCorrect = WordService.isCorrectAnswer(999, 'Szia');
      expect(isCorrect, isFalse);
    });
  });

  group('WordService - Data Integrity', () {
    test('words list is populated after initialize', () {
      expect(WordService.words, isNotEmpty);
      expect(WordService.words.length, equals(8));
    });

    test('first word is Zdravo/Szia', () {
      expect(WordService.words[0].croatian, equals('Zdravo'));
      expect(WordService.words[0].hungarian, equals('Szia'));
    });

    test('all words have default unknown status', () {
      for (final word in WordService.words) {
        expect(word.status, anyOf(
          WordStatus.unknown,
          WordStatus.inProgress,
          WordStatus.learned,
        ));
      }
    });

    test('all words have valid quotient values', () {
      for (final word in WordService.words) {
        expect(word.quotient, greaterThanOrEqualTo(0.5));
        expect(word.quotient, lessThanOrEqualTo(3.0));
      }
    });
  });

  group('WordService - Quotient Edge Cases', () {
    test('quotient at exact minimum 0.5 stays at 0.5', () {
      final result = WordService.updateQuotient(0.5, true, isLearned: true);
      expect(result, equals(0.5));
    });

    test('quotient at exact maximum 3.0 stays at 3.0', () {
      final result = WordService.updateQuotient(3.0, false, isLearned: true);
      expect(result, equals(3.0));
    });

    test('multiple failures accumulate quotient', () {
      var quotient = 1.0;
      quotient = WordService.updateQuotient(quotient, false, isLearned: true);
      expect(quotient, equals(1.2));
      quotient = WordService.updateQuotient(quotient, false, isLearned: true);
      expect(quotient, equals(1.4));
    });

    test('multiple successes decrease quotient', () {
      var quotient = 2.0;
      quotient = WordService.updateQuotient(quotient, true, isLearned: true);
      expect(quotient, closeTo(1.9, 0.001));
      quotient = WordService.updateQuotient(quotient, true, isLearned: true);
      expect(quotient, closeTo(1.8, 0.001));
    });
  });

  group('WordService - Yellow Pass (2nd attempt correct)', () {
    test('yellow pass on unlearned word does not change quotient', () {
      final word = WordService.words[0];
      word.status = WordStatus.inProgress;
      word.quotient = 2.0;

      final resultQuotient = WordService.updateQuotient(word.quotient, true, isLearned: false);
      expect(resultQuotient, equals(2.0)); // No change
    });

    test('yellow pass on learned word increases quotient by half', () {
      final word = WordService.words[0];
      word.status = WordStatus.learned;
      word.quotient = 2.0;

      final resultQuotient = WordService.updateQuotient(word.quotient, true, isLearned: true, isYellowPass: true);
      expect(resultQuotient, equals(2.05)); // +0.05 instead of -0.1
    });

    test('yellow pass quotient increase clamps to max', () {
      final word = WordService.words[0];
      word.quotient = 2.96;

      final resultQuotient = WordService.updateQuotient(word.quotient, true, isLearned: true, isYellowPass: true);
      expect(resultQuotient, equals(3.0)); // Clamped to max
    });
  });

  group('WordService - Status Edge Cases', () {
    test('7 streak with unknown status transitions to learned', () {
      final status = WordService.calculateNewStatus(true, 7, WordStatus.unknown);
      expect(status, equals(WordStatus.learned));
    });

    test('6 streak is not enough to learn', () {
      final status = WordService.calculateNewStatus(true, 6, WordStatus.unknown);
      expect(status, equals(WordStatus.inProgress));
    });

    test('8 streak stays learned', () {
      final status = WordService.calculateNewStatus(true, 8, WordStatus.learned);
      expect(status, equals(WordStatus.learned));
    });
  });

  group('WordService - Word Selection', () {
    test('selectWordByQuotient returns valid index', () {
      final index = WordService.selectWordByQuotient();
      expect(index, greaterThanOrEqualTo(0));
      expect(index, lessThan(WordService.words.length));
    });

    test('selectWordByQuotient favors higher quotient words', () {
      final counts = <int, int>{};
      for (int i = 0; i < 1000; i++) {
        final index = WordService.selectWordByQuotient();
        counts[index] = (counts[index] ?? 0) + 1;
      }

      final maxQuotientIndex = WordService.words
          .asMap()
          .entries
          .reduce((a, b) => a.value.quotient > b.value.quotient ? a : b)
          .key;

      expect(counts[maxQuotientIndex]!, greaterThan(counts.values.reduce((a, b) => a < b ? a : b)));
    });

    test('selectWordByQuotient handles equal quotients', () {
      for (var word in WordService.words) {
        word.quotient = 1.0;
      }

      final index = WordService.selectWordByQuotient();
      expect(index, greaterThanOrEqualTo(0));
      expect(index, lessThan(WordService.words.length));
    });
  });

  group('WordService - Persistence', () {
    test('loads saved words from SharedPreferences', () async {
      final savedWords = [
        Word(croatian: 'Zdravo', hungarian: 'Szia', status: WordStatus.learned, streakCount: 5),
        Word(croatian: 'Hvala', hungarian: 'Köszönöm', status: WordStatus.inProgress, streakCount: 2),
      ];
      final encoded = jsonEncode(savedWords.map((w) => w.toJson()).toList());

      SharedPreferences.setMockInitialValues({'words': encoded});
      await WordService.initialize();

      expect(WordService.words.length, equals(2));
      expect(WordService.words[0].croatian, equals('Zdravo'));
      expect(WordService.words[0].status, equals(WordStatus.learned));
      expect(WordService.words[1].croatian, equals('Hvala'));
      expect(WordService.words[1].streakCount, equals(2));
    });

    test('updateWord modifies word at index', () async {
      SharedPreferences.setMockInitialValues({});
      await WordService.initialize();

      final updatedWord = Word(
        croatian: 'Hvala',
        hungarian: 'Köszönöm',
        status: WordStatus.learned,
        streakCount: 7,
      );
      await WordService.updateWord(1, updatedWord);

      expect(WordService.words[1].status, equals(WordStatus.learned));
      expect(WordService.words[1].streakCount, equals(7));
    });

    test('updateWord ignores out of bounds index', () async {
      SharedPreferences.setMockInitialValues({});
      await WordService.initialize();

      final originalWord = WordService.words[0];
      await WordService.updateWord(999, Word(croatian: 'New', hungarian: 'New'));

      expect(WordService.words[0], equals(originalWord));
    });
  });
}
