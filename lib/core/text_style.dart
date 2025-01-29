import 'package:bookly/core/colors_app.dart';
import 'package:flutter/material.dart';

class TextStyles {
  // Keep Lobster for headings and special accents
  static const String headerFontFamily = 'Lobster';
  static const String bodyFontFamily = 'OpenSans';

  static const TextStyle headerStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: headerFontFamily,
    color: Colors.brown,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: headerFontFamily,
    color: Colors.brown,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.normal,
    color: Colors.brown,
  );

  static const TextStyle textFieldHintStyle = TextStyle(
    fontSize: 14,
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.w300,
    color: Colors.brown,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.bold,
    color: ColorStyles.backgroundColor,
  );

  static const TextStyle smallTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.w400,
    color: ColorStyles.buttonColor,
  );

  static const TextStyle richTextStyle = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.bold,
    fontFamily: headerFontFamily,
    color: ColorStyles.buttonColor,
  );

  // Additional styles:

  /// Description text (often smaller and more detailed)
  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 14,
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.normal,
    color: Colors.brown,
    height: 1.4, // for improved readability in paragraphs
  );

  /// Price style (bold and slightly larger, but you can adjust as needed)
  static const TextStyle priceStyle = TextStyle(
    fontSize: 16,
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.w700,
    color: Colors.green,
  );

  /// Links or clickable text (blue + underline for clear visual cue)
  static const TextStyle linkStyle = TextStyle(
    fontSize: 14,
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );
}
