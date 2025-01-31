import 'package:flutter/material.dart';
import '../../../core/colors_app.dart';
import '../../../core/text_style.dart';

Widget NavContainr({required IconData icon,required String title,required VoidCallback fun}){
  return  Container(
    height: 200,
    width: 200,
    child: Column(
      children: [
        IconButton(onPressed: fun, icon: Icon(icon,size:42,color: ColorStyles.buttonColor,)),
        SizedBox(height: 8,),
        Text(title,style: TextStyles.headerStyle,),
      ],
    ),
  );

}