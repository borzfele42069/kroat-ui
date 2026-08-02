import 'package:flutter/material.dart';
import '../services/word_service.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _attemptCount = 0;
  bool _isCorrect = false;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _shakeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.02, 0)).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward().then((_) => _shakeController.reverse());
  }

  Color _getBackgroundColor() {
    if (_attemptCount == 0) return Colors.white;
    if (_isCorrect) {
      return _attemptCount == 1 ? Colors.green.withValues(alpha: 0.3) : Colors.yellow.withValues(alpha: 0.3);
    }
    return Colors.red.withValues(alpha: _attemptCount == 1 ? 0.3 : 0.7);
  }

  Color _getBorderColor() {
    if (_attemptCount == 0) return Colors.grey;
    if (_isCorrect) {
      return _attemptCount == 1 ? Colors.green : Colors.yellow;
    }
    return Colors.red;
  }

  void _submit() {
    final answer = _inputController.text;
    final correct = WordService.isCorrectAnswer(_currentIndex, answer);

    setState(() {
      _isCorrect = correct;
      _attemptCount++;
    });

    if (correct || _attemptCount >= 2) {
      Future.delayed(const Duration(milliseconds: 1500), _nextWord);
    } else {
      _triggerShake();
    }
  }

  void _nextWord() {
    setState(() {
      _currentIndex = WordService.nextIndex(_currentIndex, WordService.words.length);
      _attemptCount = 0;
      _isCorrect = false;
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = WordService.words[_currentIndex].$1;

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _shakeAnimation,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(),
                      border: Border.all(color: _getBorderColor(), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      word,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (_attemptCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _isCorrect ? 'Nice!' : (_attemptCount == 1 ? 'Try again' : 'Next time'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: _isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _inputController,
              enabled: _attemptCount < 2,
              decoration: InputDecoration(
                hintText: _attemptCount == 1 && !_isCorrect ? 'Try again...' : 'Enter the Hungarian word',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _attemptCount < 2 ? _submit : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
