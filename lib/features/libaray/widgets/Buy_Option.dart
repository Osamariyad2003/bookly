import 'package:flutter/material.dart';

import '../../../core/colors_app.dart';
import '../../../core/webview_example.dart';

Widget buildBuyOption(BuildContext context, String imagePath, String name, String url) {
  return GestureDetector(
    onTap: () {
      if (url.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewExample(link: url),
          ),
        );
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: ColorStyles.backgroundColor,

          child: Image.asset(imagePath,fit: BoxFit.cover,),
        ),
        SizedBox(height: 5),
        Text(name),
      ],
    ),
  );
}
