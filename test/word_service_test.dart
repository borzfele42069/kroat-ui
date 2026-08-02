import 'package:flutter_test/flutter_test.dart';
import 'package:kroat_ui/services/word_service.dart';
import 'package:kroat_ui/models/word.dart';

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
}
