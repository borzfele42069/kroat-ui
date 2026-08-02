import 'package:flutter/material.dart';
import 'flip_card_page.dart';
import 'learn.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kroat')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlipCardPage()),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Practice'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LearnScreen()),
                );
              },
              icon: const Icon(Icons.school),
              label: const Text('Learn'),
            ),
          ],
        ),
      ),
    );
  }
}
