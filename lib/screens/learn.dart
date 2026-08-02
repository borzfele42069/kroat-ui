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
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _shakeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.02, 0)).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _inputController.dispose();
    _focusNode.dispose();
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

    _inputController.clear();

    if (correct || _attemptCount >= 2) {
      Future.delayed(const Duration(milliseconds: 1000), _nextWord);
    } else {
      _triggerShake();
      _focusNode.requestFocus();
    }
  }

  void _nextWord() {
    setState(() {
      _currentIndex = WordService.nextIndex(_currentIndex, WordService.words.length);
      _attemptCount = 0;
      _isCorrect = false;
      _inputController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    final word = WordService.words[_currentIndex].$1;
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = (screenSize.width * 0.8).clamp(0.0, 400.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: Center(
        child: SizedBox(
          width: cardWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _shakeAnimation,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    border: Border.all(color: _getBorderColor(), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          word,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_attemptCount > 0)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              _isCorrect ? 'Nice!' : (_attemptCount == 1 ? 'Try again.' : 'Next time.'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: _isCorrect
                                    ? (_attemptCount == 1 ? Colors.green[700] : Colors.yellow[700])
                                    : Colors.red[700],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      focusNode: _focusNode,
                      enabled: !_isCorrect && _attemptCount < 2,
                      onSubmitted: !_isCorrect && _attemptCount < 2 ? (_) => _submit() : null,
                      decoration: InputDecoration(
                        hintText: _attemptCount == 1 && !_isCorrect ? 'Try again...' : 'Enter the Hungarian word',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _attemptCount < 2 ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
