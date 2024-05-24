import 'package:flutter/material.dart';

final dartTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 255, 222, 37)
  ),
  scaffoldBackgroundColor: Colors.black,
  dividerColor: Colors.white10,
  primaryColor: Colors.white,
  
  
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  ),
);