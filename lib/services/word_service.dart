class WordService {
  static const List<(String, String)> words = [
    ('Zdravo', 'Szia'),
    ('Hvala', 'Köszönöm'),
    ('Molim', 'Kérem'),
    ('Da', 'Igen'),
    ('Ne', 'Nem'),
    ('Voda', 'Víz'),
    ('Hrana', 'Étel'),
    ('Kuća', 'Ház'),
  ];

  static int nextIndex(int current, int total) => (current + 1) % total;
  static int prevIndex(int current, int total) => (current - 1 + total) % total;

  static bool isCorrectAnswer(int index, String userAnswer) {
    if (index < 0 || index >= words.length) return false;
    final correctAnswer = words[index].$2;
    return userAnswer.trim().toLowerCase() == correctAnswer.toLowerCase();
  }
}
