import 'package:another_flushbar/flushbar.dart';
import 'package:bookly/core/text_style.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';
import 'custom_image_card.dart';

class BestSellerItem extends StatelessWidget {
  BookModel bookModel;
  BestSellerItem({required this.bookModel});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var heightMediaQuery = MediaQuery.of(context).size.height;
    var widthMediaQuery = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (bookModel.author!.isNotEmpty) {
          // GoRouter.of(context)
          //     .push(AppRouter.kHomeViewDetails, extra: bookModel);
        }
        else{
          Flushbar(
            message: "This Book Not Avalible",
            messageSize: 20,
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.red[400],
            ),
            margin: EdgeInsets.all(20),
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(15),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Colors.red[400],
          ).show(context);
        }
      },
      child: SizedBox(
        height: 125,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4.5,
              child: CustomBookImage(
                  imagePath: bookModel.bookImage),
            ),
            SizedBox(
              width: widthMediaQuery * 0.07,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthMediaQuery * 0.5,
                    child: Text(
                      bookModel.title ?? "",
                      style:TextStyles.subHeaderStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    bookModel.author??"Unknown Author",
                    style: TextStyles.subHeaderStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Text(
                        "${bookModel.price ?? "free"}",
                        style: TextStyles.subHeaderStyle,
                      ),
                      Text(
                        bookModel.price ?? "",
                        style: TextStyles.subHeaderStyle,
                      ),
                       Spacer(),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}