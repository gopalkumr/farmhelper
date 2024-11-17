import 'package:flutter/material.dart';
import 'package:farmhelp/helper/colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.lightGreen,
      primaryColor: ColorSys.kPrimary,
      scaffoldBackgroundColor: ColorSys.kBackgroundColor,
      fontFamily: 'NetflixSans',
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: ColorSys.kTextColor,
            fontFamily: "NetflixSans",
            fontWeight: FontWeight.bold),
        bodyMedium:
            TextStyle(color: ColorSys.kTextColor, fontFamily: "NetflixSans"),
      ));
}
