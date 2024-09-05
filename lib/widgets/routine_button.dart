// widgets/routine_button.dart
import 'package:flutter/material.dart';

class RoutineButton extends StatelessWidget {
  final ValueNotifier<String> currentTextNotifier;
  final String originalText;
  final String cell;
  final Function(String, String, String) onPressedCallback;

  const RoutineButton({
    required this.currentTextNotifier,
    required this.originalText,
    required this.cell,
    required this.onPressedCallback,
  });

  String _cycleButtonText(String currentText) {
    if (currentText == "◯") {
      return "／";
    } else if (currentText == "／") {
      return "☓";
    } else {
      return originalText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentTextNotifier,
      builder: (context, currentText, _) {
        return ElevatedButton(
          onPressed: () {
            final newText = _cycleButtonText(currentText);
            currentTextNotifier.value = newText;
            onPressedCallback(newText, originalText, cell);
          },
          child: Text(currentText),
        );
      },
    );
  }
}
