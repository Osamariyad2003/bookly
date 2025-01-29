import 'package:bookly/core/aseets_data.dart';
import 'package:bookly/core/colors_app.dart';
import 'package:bookly/core/utlis.dart';
import 'package:bookly/features/libaray/controller/libaray_cubit.dart';
import 'package:bookly/features/libaray/controller/libaray_states.dart';
import 'package:bookly/features/libaray/views/book_details.dart';
import 'package:bookly/features/libaray/widgets/custom_image_card.dart';
import 'package:bookly/features/libaray/widgets/custom_item_card.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibarayScreen extends StatelessWidget {
  const LibarayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibarayCubit,LibarayStates>(
      listener: (BuildContext context, LibarayStates state) {  },
      builder: (BuildContext context, LibarayStates state) {
        var cubit = context.read<LibarayCubit>();
        return Scaffold(
          appBar:DefaultAppBar(context),
          backgroundColor: ColorStyles.backgroundColor,
          body:  ConditionalBuilder(
              condition: state is! LibararyLoadingState,
              fallback: (context) => Center(child: CircularProgressIndicator(),),
              builder:(context)=> Padding(
                  padding:  EdgeInsets.all(20.0),
                    child: SingleChildScrollView(child: Column(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 300,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BookDetail(bookModel: cubit.books!.books![index])));
                                },
                                  child: CustomBookImage(imagePath: cubit.books?.books?[index].bookImage));
                            },
                                separatorBuilder: (context,index)=> SizedBox(width: 20,),
                                itemCount: cubit.books?.books?.length ??3,),
                          ),
                          SizedBox(height: 20,),
                          Text('Best Seller'),
                          SizedBox(
                            height: 600,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BookDetail(bookModel: cubit.books!.books![index])));
                                  },
                                  child: ListTile(
                                    leading:Container(
                                      height: 180,
                                        child: CustomItemCard(imagePath: cubit.books?.books?[index].bookImage)) ,
                                    title: Text('${cubit.books?.books?[index].title}'),
                                    subtitle: Text('${cubit.books?.books?[index].author}'),
                                    trailing:cubit.books?.books?[index].price =="0.00"? Text('Free'):Text('${cubit.books?.books?[index].price}'),
                                  ),
                                );
                              },
                              separatorBuilder: (context,index)=> SizedBox(width: 20,),
                              itemCount: cubit.books?.books?.length??3,),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
        );
      },
    );
  }
}
