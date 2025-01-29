import 'package:bookly/core/aseets_data.dart';
import 'package:bookly/core/colors_app.dart';
import 'package:bookly/core/utlis.dart';
import 'package:bookly/core/webview_example.dart';
import 'package:bookly/features/libaray/models/book_model.dart';
import 'package:bookly/features/libaray/widgets/custom_image_card.dart';
import 'package:flutter/material.dart';

import '../../../core/text_style.dart';
import '../widgets/Buy_Option.dart';

class BookDetail extends StatelessWidget {
  final BookModel bookModel;

  const BookDetail({super.key, required this.bookModel});

  @override
  Widget build(BuildContext context) {
    var heightMediaQuery = MediaQuery.of(context).size.height;
    var widthMediaQuery = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: DefaultAppBar(context),
      backgroundColor: ColorStyles.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
             Column(
                  children: [
                    CustomBookImage(imagePath: bookModel.bookImage),
                     SizedBox(height: 10),
                    Text(bookModel.title??"",style: TextStyles.headerStyle,),
                     SizedBox(height: 10),
                    Text(bookModel.author??"",style: TextStyles.subHeaderStyle,),
                  ],
                ),
               SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                  child: Text(bookModel.title??"Unkomwn", style: TextStyles.subHeaderStyle,textAlign: TextAlign.left,)),
               SizedBox(height: 10),
              Text(bookModel.description??""),
               SizedBox(height: 20),
              Row(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text('Published by ${bookModel.publisher}',style: TextStyles.subHeaderStyle,textAlign: TextAlign.left,)),
                  SizedBox(width: widthMediaQuery * 0.1),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(bookModel.price == "0.00" ? 'Free' : bookModel.price??"",style: TextStyles.subHeaderStyle,textAlign: TextAlign.right,)),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  const Text('You can buy the book from these sites'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildBuyOption(
                        context,
                        AseetsData.Amazon,
                        'Amazon',
                        bookModel.buyLinks?.isNotEmpty == true ? bookModel.buyLinks![0].url??"" : "",
                      ),
                      const SizedBox(width: 20),
                      buildBuyOption(
                        context,
                        AseetsData.Apple,
                        'Apple',
                        bookModel.buyLinks != null && bookModel.buyLinks!.length > 1
                            ? bookModel.buyLinks![1].url??""
                            : "",
                      ),
                      const SizedBox(width: 20),
                      buildBuyOption(
                        context,
                        AseetsData.Millons,
                        'Books-A-Million',
                        bookModel.buyLinks != null && bookModel.buyLinks!.length > 2
                            ? bookModel.buyLinks![2].url??""
                            : "",
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
