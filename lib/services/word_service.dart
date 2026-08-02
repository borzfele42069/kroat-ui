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

  static List<(String, String)> getWords() => words;
}
