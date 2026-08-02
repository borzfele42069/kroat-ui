import 'package:flutter/material.dart';
import '../services/word_service.dart';
import '../models/word.dart';
import '../config/ui_constants.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;
  final _inputController = TextEditingController();
  final _focusNode = FocusNode();

  int _currentIndex = 0;
  int _attemptCount = 0;
  bool _isCorrect = false;
  bool _answerRevealed = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(duration: const Duration(milliseconds: UIConstants.shakeAnimationDuration), vsync: this);
    _shakeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.02, 0)).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _selectNextWord();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  void _selectNextWord() {
    _currentIndex = WordService.selectWordByQuotient();
    _attemptCount = 0;
    _isCorrect = false;
    _answerRevealed = false;
    _inputController.clear();
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
      return _attemptCount == 1
        ? UIConstants.colorCorrectFirstTry
        : UIConstants.colorCorrectSecondTry;
    }
    return _attemptCount == 1 ? UIConstants.colorIncorrectFirst : UIConstants.colorIncorrectSecond;
  }

  void _submit() {
    final answer = _inputController.text;
    final correct = WordService.isCorrectAnswer(_currentIndex, answer);

    setState(() {
      _isCorrect = correct;
      _attemptCount++;
    });

    _inputController.clear();

    if (correct) {
      _handleCorrectAnswer();
    } else if (_attemptCount >= 2) {
      _handleSecondFailure();
    } else {
      _triggerShake();
      _focusNode.requestFocus();
    }
  }

  void _handleCorrectAnswer() {
    setState(() {
      _answerRevealed = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      final word = WordService.words[_currentIndex];
      final isYellowPass = _attemptCount == 1;

      word.lastReviewedAt = DateTime.now();
      word.quotient = WordService.updateQuotient(word.quotient, true, isLearned: word.status == WordStatus.learned, isYellowPass: isYellowPass);

      if (isYellowPass) {
        if (word.status == WordStatus.learned) {
          word.streakCount++;
        }
      } else {
        word.streakCount++;
        word.status = WordService.calculateNewStatus(true, word.streakCount, word.status);
      }

      WordService.updateWord(_currentIndex, word);
      _selectNextWord();
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    });
  }

  void _handleSecondFailure() {
    setState(() {
      _answerRevealed = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      final word = WordService.words[_currentIndex];
      word.lastReviewedAt = DateTime.now();
      word.quotient = WordService.updateQuotient(word.quotient, false, isLearned: word.status == WordStatus.learned);

      if (word.status == WordStatus.learned && WordService.shouldRevertToInProgress(word.quotient)) {
        word.status = WordStatus.inProgress;
        word.streakCount = 0;
      } else if (word.status != WordStatus.learned) {
        word.status = WordStatus.inProgress;
        word.streakCount = 0;
      }

      WordService.updateWord(_currentIndex, word);
      _selectNextWord();
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = WordService.words[_currentIndex];
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = (screenSize.width * UIConstants.cardWidthPercent).clamp(0.0, UIConstants.cardWidthMax);

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
                  height: UIConstants.cardHeightLearn,
                  padding: const EdgeInsets.all(UIConstants.spacing24),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                    boxShadow: UIConstants.boxShadow,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          _answerRevealed ? word.hungarian : word.croatian,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: UIConstants.fontSizeWordCard,
                            fontWeight: FontWeight.bold,
                            color: _answerRevealed ? UIConstants.colorTextWhite : Colors.black,
                          ),
                        ),
                      ),
                      if (_attemptCount > 0)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              _isCorrect ? 'Nice!' : 'Try again.',
                              style: TextStyle(
                                fontSize: UIConstants.fontSizeMessage,
                                fontWeight: FontWeight.w500,
                                color: _isCorrect
                                    ? (_attemptCount == 1 ? UIConstants.colorMessageCorrectFirst : UIConstants.colorMessageCorrectSecond)
                                    : UIConstants.colorMessageIncorrect,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: UIConstants.spacing40),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                        boxShadow: UIConstants.boxShadow,
                      ),
                      child: TextField(
                        controller: _inputController,
                        focusNode: _focusNode,
                        enabled: !_isCorrect && _attemptCount < 2,
                        onSubmitted: !_isCorrect && _attemptCount < 2 ? (_) => _submit() : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: _attemptCount == 1 && !_isCorrect ? 'Try again...' : 'Enter the Hungarian word',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: UIConstants.spacing12, vertical: UIConstants.spacing16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: UIConstants.spacing8),
                  ElevatedButton(
                    onPressed: _attemptCount < 2 ? _submit : null,
                    child: const Text('Submit'),
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
