import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData themeData() {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0xFFB2EBF2),
    fontFamily: 'TsunagiGothic',
    appBarTheme: const AppBarTheme(
      color: Color(0xFF333333),
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: Color(0xFF333333),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFF333333)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF333333), fontSize: 18),
      bodyMedium: TextStyle(color: Color(0xFF333333), fontSize: 16),
      bodySmall: TextStyle(color: Color(0xFF333333), fontSize: 14),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
