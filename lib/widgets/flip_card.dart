import 'package:flutter/material.dart';
import 'dart:math';
import '../config/ui_constants.dart';

class FlipCard extends StatefulWidget {
  final String croatian;
  final String hungarian;

  const FlipCard({super.key, required this.croatian, required this.hungarian});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: UIConstants.flipAnimationDuration), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFlipped = _animation.value > 0.5;
          final angle = _animation.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFlipped ? UIConstants.gradientBack : UIConstants.gradientFront,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
                ),
                child: Center(
                  child: Transform(
                    transform: Matrix4.identity()..rotateY(-angle),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isFlipped ? 'Hungarian' : 'Croatian',
                          style: const TextStyle(color: UIConstants.colorTextHint, fontSize: UIConstants.fontSizeLabel),
                        ),
                        const SizedBox(height: UIConstants.spacing8),
                        Text(
                          isFlipped ? widget.hungarian : widget.croatian,
                          style: const TextStyle(
                            color: UIConstants.colorTextWhite,
                            fontSize: UIConstants.fontSizeWordCard,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
