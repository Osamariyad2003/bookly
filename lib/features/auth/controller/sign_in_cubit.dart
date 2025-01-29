


import 'package:bookly/core/dio_helper.dart';
import 'package:bookly/features/auth/controller/sign_in_state.dart';
import 'package:bookly/features/auth/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  UserModel? model;

  SignInCubit() : super(SignInInitialState());
   DioHelper?  _apiService; // Inject your API service
  Future<void> signIn(String email, String password) async {
    emit(SignInLoadingState());
       await DioHelper.postData(url: 'http://192.168.1.78:5000/login', data: {
        'email':email,
         'pass':password
      }).then((value){
        if(value != null){
            value.data = model?.toJson();
          emit(SignInSuccessState());
          _getUser();
        }
      }).catchError((error){
        emit(SignInErrorState(error));
        // Emit error state if sign-in fails
      });
  }

  Future<void> _getUser() async {
    emit(GetUserLoadingState());
    DioHelper.getData(url: 'users').then((value){
      emit(GetUserSuccessState());

    }).catchError((error){
      emit(GetUserErrorState("Error fetching user: $error")); // Emit error in case of failure


    });

    try {
      final user = await _apiService?.getUserData();

      if (user != null) {
        emit(GetUserSuccessState()); // Emit success state if user is fetched successfully
      } else {
        emit(GetUserErrorState("User not found")); // Emit error if user data is not found
      }
    } catch (error) {
      emit(GetUserErrorState("Error fetching user: $error")); // Emit error in case of failure
    }
  }
}


