import 'package:flutter/material.dart';

import 'widget_theme/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      primaryColor: Colors.red,
      brightness: Brightness.light,
      textTheme: AppTextTheme.lightTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(),
      ),
      colorScheme: const ColorScheme.light(background: Colors.white));
  static ThemeData darkTheme = ThemeData(
      // primaryColor: Colors.black,
      brightness: Brightness.dark,
      textTheme: AppTextTheme.darkTextTheme,
      colorScheme: const ColorScheme.dark(background: Colors.black));
}
