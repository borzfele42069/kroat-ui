enum WordStatus { unknown, inProgress, learned }

class Word {
  final String croatian;
  final String hungarian;
  WordStatus status;
  int streakCount;
  double quotient;
  DateTime? lastReviewedAt;

  Word({
    required this.croatian,
    required this.hungarian,
    this.status = WordStatus.unknown,
    this.streakCount = 0,
    this.quotient = 1.0,
    this.lastReviewedAt,
  });

  Map<String, dynamic> toJson() => {
    'croatian': croatian,
    'hungarian': hungarian,
    'status': status.toString(),
    'streakCount': streakCount,
    'quotient': quotient,
    'lastReviewedAt': lastReviewedAt?.toIso8601String(),
  };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    croatian: json['croatian'] as String,
    hungarian: json['hungarian'] as String,
    status: _parseStatus(json['status'] as String),
    streakCount: json['streakCount'] as int? ?? 0,
    quotient: (json['quotient'] as num?)?.toDouble() ?? 1.0,
    lastReviewedAt: json['lastReviewedAt'] != null
        ? DateTime.parse(json['lastReviewedAt'] as String)
        : null,
  );

  static WordStatus _parseStatus(String status) {
    return WordStatus.values.firstWhere(
      (e) => e.toString() == status,
      orElse: () => WordStatus.unknown,
    );
  }
}
