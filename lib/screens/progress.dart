import 'package:flutter/material.dart';
import '../services/word_service.dart';
import '../models/word.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: WordService.words.length,
          itemBuilder: (context, index) {
            final word = WordService.words[index];
            return Card(
              child: ListTile(
                title: Text(word.croatian),
                subtitle: Text(word.hungarian),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(word.status),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        word.status.name,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Streak: ${word.streakCount}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      'Q: ${word.quotient.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(WordStatus status) {
    switch (status) {
      case WordStatus.unknown:
        return Colors.grey;
      case WordStatus.inProgress:
        return Colors.blue;
      case WordStatus.learned:
        return Colors.green;
    }
  }
}
