import 'package:bookly/core/colors_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'aseets_data.dart';

PreferredSizeWidget DefaultAppBar(BuildContext context,){
  return AppBar(
    centerTitle: true,
    leading:  IconButton(onPressed: (){
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back_ios,color: ColorStyles.backgroundColor,)),
    title: Image.asset(
      AseetsData.SplachImage,
      height: 30,
      fit: BoxFit.cover,
    ),
    backgroundColor: ColorStyles.buttonColor,
  );
}
Widget myFormField({
  required String hint,
  required TextInputType type,
  required int maxLines,
  double radius = 15,
  String? title = "",
  bool readOnly = false,
  TextStyle? hintStyle,
  IconData? suffixIcon,
  VoidCallback? suffixIconPressed,
  Widget? widget,
  TextEditingController? controller,
  dynamic validation,
  bool isPassword = false,
  Color? fill,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null && title.isNotEmpty)
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      if (title != null && title.isNotEmpty)
        const SizedBox(
          height: 5,
        ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          style: const TextStyle(color: ColorStyles.backgroundColor),
          readOnly: readOnly,
          obscureText: isPassword,
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: fill,
            focusColor: ColorStyles.backgroundColor,
            hintText: hint,
            hintStyle: hintStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.textFieldBorderColor),
              borderRadius: BorderRadius.circular(radius),
            ),
            suffixIcon: suffixIcon != null
                ? IconButton(
              onPressed: suffixIconPressed,
              icon: Icon(
                suffixIcon,
                color: ColorStyles.buttonColor,
              ),
            )
                : null,
          ),
          validator: validation,
        ),
      ),
    ],
  );
}
