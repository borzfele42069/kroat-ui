import 'package:flutter/material.dart';
import '../services/word_service.dart';
import '../models/word.dart';
import '../config/ui_constants.dart';

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
            padding: const EdgeInsets.all(UIConstants.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress', style: const TextStyle(fontSize: UIConstants.fontSizeLarge, fontWeight: FontWeight.w500)),
                    Text('$learnedCount / $total learned', style: const TextStyle(fontSize: UIConstants.fontSizeLabel, color: UIConstants.colorTextSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
                  child: SizedBox(
                    height: UIConstants.progressBarHeight,
                    child: Row(
                      children: [
                        if (unknownCount > 0)
                          Expanded(
                            flex: unknownCount,
                            child: Container(color: UIConstants.colorStatusUnknown),
                          ),
                        if (inProgressCount > 0)
                          Expanded(
                            flex: inProgressCount,
                            child: Container(color: UIConstants.colorStatusInProgress),
                          ),
                        if (learnedCount > 0)
                          Expanded(
                            flex: learnedCount,
                            child: Container(color: UIConstants.colorStatusLearned),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: UIConstants.spacing12),
                Row(
                  children: [
                    _buildStatusLegend('Unknown', UIConstants.colorStatusUnknown, unknownCount),
                    SizedBox(width: UIConstants.spacing16),
                    _buildStatusLegend('In Progress', UIConstants.colorStatusInProgress, inProgressCount),
                    SizedBox(width: UIConstants.spacing16),
                    _buildStatusLegend('Learned', UIConstants.colorStatusLearned, learnedCount),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacing16),
              child: ListView.builder(
                itemCount: WordService.words.length,
                itemBuilder: (context, index) {
            final word = WordService.words[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacing16, vertical: UIConstants.spacing12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(word.croatian, style: const TextStyle(fontSize: UIConstants.fontSizeTitle, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacing8, vertical: UIConstants.spacing4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(word.status),
                        borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
                      ),
                      child: Text(
                        word.status.displayName,
                        style: const TextStyle(fontSize: UIConstants.fontSizeLabel, color: UIConstants.colorTextWhite),
                      ),
                    ),
                    SizedBox(width: UIConstants.spacing16),
                    Text(
                      'Streak: ${word.streakCount}',
                      style: const TextStyle(fontSize: UIConstants.fontSizeLabel, color: UIConstants.colorTextSecondary),
                    ),
                    SizedBox(width: UIConstants.spacing16),
                    Text(
                      'Q: ${word.quotient.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: UIConstants.fontSizeLabel, color: UIConstants.colorTextSecondary),
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
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall))),
          const SizedBox(height: UIConstants.spacing4),
          Text(label, style: const TextStyle(fontSize: UIConstants.fontSizeHint)),
          Text(count.toString(), style: const TextStyle(fontSize: UIConstants.fontSizeSmall, color: UIConstants.colorTextSecondary)),
        ],
      ),
    );
  }
}
