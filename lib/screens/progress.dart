import 'package:flutter/material.dart';
import '../services/word_service.dart';
import '../models/word.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unknownCount = WordService.words.where((w) => w.status == WordStatus.unknown).length;
    final inProgressCount = WordService.words.where((w) => w.status == WordStatus.inProgress).length;
    final learnedCount = WordService.words.where((w) => w.status == WordStatus.learned).length;
    final total = WordService.words.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    Text('$learnedCount / $total learned', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: [
                        if (unknownCount > 0)
                          Expanded(
                            flex: unknownCount,
                            child: Container(color: Colors.grey),
                          ),
                        if (inProgressCount > 0)
                          Expanded(
                            flex: inProgressCount,
                            child: Container(color: Colors.blue),
                          ),
                        if (learnedCount > 0)
                          Expanded(
                            flex: learnedCount,
                            child: Container(color: Colors.green),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatusLegend('Unknown', Colors.grey, unknownCount),
                    const SizedBox(width: 16),
                    _buildStatusLegend('In Progress', Colors.blue, inProgressCount),
                    const SizedBox(width: 16),
                    _buildStatusLegend('Learned', Colors.green, learnedCount),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: WordService.words.length,
                itemBuilder: (context, index) {
            final word = WordService.words[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(word.croatian, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
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
                    const SizedBox(width: 16),
                    Text(
                      'Streak: ${word.streakCount}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Q: ${word.quotient.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
              ),
            ),
          ),
        ],
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

  Widget _buildStatusLegend(String label, Color color, int count) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
          Text(count.toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
