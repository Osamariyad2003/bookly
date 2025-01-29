import 'package:bookly/core/colors_app.dart';
import 'package:bookly/core/text_style.dart';
import 'package:flutter/material.dart';

Widget customButton({
  required String text,
  required VoidCallback onPressed,
  Color? color,
  EdgeInsetsGeometry? padding,
  double borderRadius = 8.0,
  TextStyle? textStyle,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? ColorStyles.buttonColor,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    onPressed: onPressed,
    child: Container(
      height: 30,
      width: double.infinity,
      child: Center(
        child: Text(
          text,
          style: textStyle ?? TextStyles.buttonTextStyle,
        ),
      ),
    ),
  );
}



