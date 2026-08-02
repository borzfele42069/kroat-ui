/// Business logic constants: learning algorithm, data persistence
class AppConstants {
  // Quotient (SM-2 algorithm) parameters
  static const double quotientMin = 0.5;
  static const double quotientMax = 3.0;
  static const double quotientDecrement = 0.1; // Correct answer
  static const double quotientIncrement = 0.2; // Incorrect answer

  // Learning progression
  static const int streakRequiredForLearned = 7;
  static const double quotientThresholdForRevert = 3.0;

  // SharedPreferences keys
  static const String prefKeyWords = 'words';
}
