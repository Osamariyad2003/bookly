import 'package:bookly/core/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book_model.dart';
import 'libaray_states.dart';

class LibarayCubit extends Cubit<LibarayStates> {
  Books? books;
  LibarayCubit():super(LibararyIntialState());
  
  void getBooks(){
    emit(LibararyLoadingState());
    DioHelper.getData(url: "https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json",
      query: {
      "api-key" :"jbhTxn6mfZxn0K7F7UsaGuzmwzJPEGao"
      }).then((value){
      print(value.data);
      books = Books.fromJson(value.data["results"]); // Fix: Use "results" instead of "books"
        emit(LibararySuccessState());

    }).catchError((e){
      print(e);
      emit(LibararyErrorState());
    });
  }

}
