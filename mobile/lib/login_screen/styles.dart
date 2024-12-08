import 'package:flutter/material.dart';

class AppColors {
  static const darkGrey = Color.fromARGB(255, 255, 255, 255);
  static const orange = Color.fromARGB(251, 255, 111, 0);
}

class TextStyles {
  static TextStyle title = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.darkGrey,
  );

  static TextStyle body = const TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black,
  );
}