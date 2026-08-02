import 'package:flutter/material.dart';
import '../widgets/flip_card.dart';
import '../services/word_service.dart';

class FlipCardPage extends StatefulWidget {
  const FlipCardPage({super.key});

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {
  int _currentIndex = 0;

  List get words => WordService.words;

  void _previousCard() {
    setState(() {
      _currentIndex = WordService.prevIndex(_currentIndex, words.length);
    });
  }

  void _nextCard() {
    setState(() {
      _currentIndex = WordService.nextIndex(_currentIndex, words.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = words[_currentIndex];
    final screenSize = MediaQuery.of(context).size;
    final cardSize = (screenSize.width * 0.8).clamp(0.0, 400.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Kroat Flashcards')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: cardSize,
              height: cardSize,
              child: FlipCard(
                key: ValueKey(_currentIndex),
                croatian: current.croatian,
                hungarian: current.hungarian,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _previousCard,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Exit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _nextCard,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
