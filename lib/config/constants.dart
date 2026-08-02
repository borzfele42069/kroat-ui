/// Application-wide constants and configuration parameters
class AppConstants {
  // Quotient (SM-2 algorithm) parameters
  static const double quotientMin = 0.5;
  static const double quotientMax = 3.0;
  static const double quotientDecrement = 0.1; // Correct answer
  static const double quotientIncrement = 0.2; // Incorrect answer

  // Learning progression
  static const int streakRequiredForLearned = 7;
  static const double quotientThresholdForRevert = 3.0;

  // Animation durations (milliseconds)
  static const int shakeAnimationDuration = 300;
  static const int revealDelayMs = 800;

  // Font sizes
  static const double fontSizeWordCard = 36;
  static const double fontSizeMessage = 18;
  static const double fontSizeStatus = 12;
  static const double fontSizeHint = 11;

  // UI dimensions
  static const double cardWidthPercent = 0.8;
  static const double cardWidthMax = 400.0;
  static const double cardHeightLearn = 200;
  static const double cardSizeFlip = 400.0;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing40 = 40;

  // Text strings
  static const String msgNice = 'Nice!';
  static const String msgTryAgain = 'Try again.';
  static const String hintEnterHungarian = 'Enter the Hungarian word';
  static const String hintTryAgain = 'Try again...';
  static const String appBarLearn = 'Learn';
  static const String appBarProgress = 'Progress';
  static const String appBarFlashcards = 'Kroat Flashcards';
  static const String appBarMainMenu = 'Kroat UI';
  static const String buttonSubmit = 'Submit';
  static const String buttonBack = 'Back';
  static const String buttonExit = 'Exit';
  static const String buttonNext = 'Next';

  // SharedPreferences keys
  static const String prefKeyWords = 'words';
}
