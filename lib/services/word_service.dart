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
}
