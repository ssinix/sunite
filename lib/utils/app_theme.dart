import 'package:flutter/material.dart';
import 'package:sunite/utils/app_colors.dart';

// App-wide theme; Material widgets read their colors and font from here
class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
    fontFamily: 'Inter',
  );
}
