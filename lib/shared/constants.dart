import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF050505);
  static const Color text = Color(0xFFCDCDCD);
  static const LinearGradient gradient = LinearGradient(
    colors: [Color(0xFFFFC8C8), Color(0xFFC8FFC8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStyles {
  static const TextStyle titleText = TextStyle(
    fontSize: 32,
    color: AppColors.text,
    fontWeight: FontWeight.bold,
    fontFamily: 'Audiowide',
  );

  static const TextStyle regularText = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );
}