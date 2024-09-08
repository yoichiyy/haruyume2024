// widgets/home_card_widget_kakei.dart
import 'package:flutter/material.dart';

class HomeCardWidgetKakei extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const HomeCardWidgetKakei({
    super.key,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 20)),
          child,
        ],
      ),
    );
  }
}
