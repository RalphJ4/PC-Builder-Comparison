import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();
  static const displayLarge = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const displayMedium = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static const bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static const price = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
