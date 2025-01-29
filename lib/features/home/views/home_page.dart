import 'package:bookly/core/app_routes.dart';
import 'package:bookly/features/home/widgets/nav_container.dart';
import 'package:flutter/material.dart';

import '../../../core/colors_app.dart';
import '../../../core/routes.dart';
import '../../../core/text_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        title:Image.asset(height: 30,"aseets/images/spalch_image.png",fit: BoxFit.cover,) ,
        backgroundColor: ColorStyles.buttonColor,
      ),
      backgroundColor: ColorStyles.backgroundColor,
      body: Padding(
        padding:  EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('This Our app Bookly AI its gives u summrize of your book and libary books  ',style: TextStyles.subHeaderStyle,),
            SizedBox(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  NavContainr(icon: Icons.computer, title: 'Summrize', fun: (){
                    Navigator.pushNamed(context, Routes.summarize);
                  }),
                  NavContainr(icon: Icons.menu_book_sharp, title: 'Libaray', fun: (){
                    Navigator.pushNamed(context, Routes.books);
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
