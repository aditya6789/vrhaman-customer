import 'package:flutter/material.dart';
 Widget ImageCard (String imagePath, bool isCorrect) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
        Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? Colors.green : Colors.red,
          size: 24,
        ),
      ],
    );
  }