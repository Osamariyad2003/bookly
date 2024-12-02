import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle headerStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'Lobster',
    color: Colors.brown,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.brown,
  );

  static const TextStyle textFieldHintStyle = TextStyle(
    color: Colors.brown,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle signInTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.brown,
  );
  static const TextStyle richTextStyle = TextStyle(
    fontSize: 80, // Large font size for "H"
    fontWeight: FontWeight.bold,
    color: Colors.brown,
    fontFamily: 'Lobster', // Use a cursive or custom font
  );
}
