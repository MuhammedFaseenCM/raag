import 'package:flutter/material.dart';

class AppColors {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      secondaryColor,
      primaryColor
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color primaryColor = Colors.blue;
  static const Color lightPrimaryColor = Colors.lightBlue;
  static const Color secondaryColor = Colors.blueGrey;
  static const Color whiteColor = Colors.white;

  static const Color transparentColor = Colors.transparent;
}
