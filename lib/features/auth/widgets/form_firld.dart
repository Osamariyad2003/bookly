import 'package:flutter/material.dart';

Widget customTextFormField({
  required String hint,
  required TextEditingController controller,
  required String? Function(String?)? validator,
  Widget? icon,
  Widget? suffixIcon,
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
  Color fillColor = Colors.white,
  Color borderColor = Colors.grey,
  double borderRadius = 8.0,
  TextStyle? hintStyle,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: isPassword,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: hintStyle ?? TextStyle(color: Colors.grey),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      prefixIcon: icon,
      suffixIcon: suffixIcon,
    ),
  );
}
