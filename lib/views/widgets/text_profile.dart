import 'package:flutter/material.dart';

class TextColumnProfile extends StatelessWidget {
  final String num;
  final String content;

  const TextColumnProfile({
    super.key,
    required this.num,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          num,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
