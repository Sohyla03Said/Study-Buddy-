import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.highContrastText,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.highContrastText,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.highContrastText,
    height: 1.4,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.highContrastText,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.highContrastText,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
    height: 1.4,
  );
}