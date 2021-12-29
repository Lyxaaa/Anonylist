import 'package:flutter/material.dart';

// Theming generator https://flutter-theme-editor.rob-b.co.uk/#/
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.standard,
  primarySwatch: Colors.blue,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)),
          primary: Colors.grey,
          textStyle: const TextStyle(fontSize: 17, color: Colors.black),
          elevation: 30.0,
          shadowColor: Colors.black
      )
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.standard,
  primarySwatch: Colors.blue,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          //primary: Colors.grey,
          textStyle: const TextStyle(fontSize: 17, color: Colors.black),
          elevation: 30.0,
          shadowColor: Colors.black
      )
  ),
);