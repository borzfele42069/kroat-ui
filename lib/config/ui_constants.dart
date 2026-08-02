import 'package:flutter/material.dart';

/// UI styling constants: colors, fonts, spacing, animations
class UIConstants {
  // Animation durations (milliseconds)
  static const int flipAnimationDuration = 300;
  static const int shakeAnimationDuration = 300;
  static const int revealDelayMs = 800;

  // Card dimensions
  static const double cardWidthPercent = 0.8;
  static const double cardWidthMax = 400.0;
  static const double cardHeightLearn = 200;

  // Font sizes
  static const double fontSizeWordCard = 36;
  static const double fontSizeLabel = 12;
  static const double fontSizeMessage = 18;
  static const double fontSizeHint = 11;
  static const double fontSizeSmall = 10;

  // Spacing and padding
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing24 = 24;
  static const double spacing40 = 40;

  // Border radius
  static const double borderRadiusSmall = 4;
  static const double borderRadiusMedium = 8;
  static const double borderRadiusLarge = 12;

  // Colors
  static const Color colorStatusUnknown = Colors.grey;
  static const Color colorStatusInProgress = Colors.blue;
  static const Color colorStatusLearned = Colors.green;
  static const Color colorTextHint = Colors.white70;
  static const Color colorTextWhite = Colors.white;
  static const Color colorCardElevation = Colors.black12;

  // Gradient colors for flip card
  static const List<Color> gradientFront = [Colors.blue, Colors.purple];
  static const List<Color> gradientBack = [Colors.orange, Colors.red];

  // Box shadow
  static const boxShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // Progress bar height
  static const double progressBarHeight = 8;

  // Card elevation
  static const double cardElevation = 4;
}
