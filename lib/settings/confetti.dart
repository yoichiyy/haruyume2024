import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// StatefulWidgetとして定義
class CustomConfettiWidget extends StatefulWidget {
  final ConfettiController controller;

  const CustomConfettiWidget({
    required this.controller,
    super.key,
  });

  @override
  CustomConfettiWidgetState createState() => CustomConfettiWidgetState();
}

class CustomConfettiWidgetState extends State<CustomConfettiWidget> {
  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: widget.controller,
      blastDirectionality: BlastDirectionality.explosive,
      blastDirection: pi / 2,
      emissionFrequency: 0.9,
      minBlastForce: 5,
      maxBlastForce: 10,
      numberOfParticles: 7,
      gravity: 0.5,
      colors: const <Color>[
        Colors.red,
        Colors.blue,
        Colors.green,
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();  // コントローラーのクリーンアップ
    super.dispose();
  }
}
