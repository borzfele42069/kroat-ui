import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

class WordService {
  static final List<Word> _defaultWords = [
    Word(croatian: 'Zdravo', hungarian: 'Szia'),
    Word(croatian: 'Hvala', hungarian: 'Köszönöm'),
    Word(croatian: 'Molim', hungarian: 'Kérem'),
    Word(croatian: 'Da', hungarian: 'Igen'),
    Word(croatian: 'Ne', hungarian: 'Nem'),
    Word(croatian: 'Voda', hungarian: 'Víz'),
    Word(croatian: 'Hrana', hungarian: 'Étel'),
    Word(croatian: 'Kuća', hungarian: 'Ház'),
  ];

  static late List<Word> words;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('words');

    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      words = decoded.map((w) => Word.fromJson(w as Map<String, dynamic>)).toList();
    } else {
      words = _defaultWords;
      await _saveWords();
    }
  }

  static Future<void> _saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(words.map((w) => w.toJson()).toList());
    await prefs.setString('words', encoded);
  }

  static Future<void> updateWord(int index, Word word) async {
    if (index >= 0 && index < words.length) {
      words[index] = word;
      await _saveWords();
    }
  }

  static int nextIndex(int current, int total) => (current + 1) % total;
  static int prevIndex(int current, int total) => (current - 1 + total) % total;

  static bool isCorrectAnswer(int index, String userAnswer) {
    if (index < 0 || index >= words.length) return false;
    final correctAnswer = words[index].hungarian;
    return userAnswer.trim().toLowerCase() == correctAnswer.toLowerCase();
  }
}
