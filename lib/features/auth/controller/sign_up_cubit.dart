import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookly/features/auth/controller/sign_up_state.dart';
import '../../../core/dio_helper.dart';
class SignUpCubit extends Cubit<SignUpState>{

  SignUpCubit() :super(SignUpInitialState());
  DioHelper? _apiService;


  Future<void> signUp(String name,String password,String email,String phoneNumber) async {
    emit(SignUpLoadingState());
    await DioHelper.postData(url: 'http://192.168.1.78:5000/register', data: {
      'username':name,
      'password':password,
      'email':email,
      'phone':phoneNumber,
    }).then((value){
      print(value);
      emit(SignUpSuccessState());
    }).catchError((error){
      print(error);
      emit(SignUpErrorState());
    });
  }

  Future<void> _getUser() async {
    emit(GetUserLoadingState()); // Emit loading state when fetching user data

    try {
      // Call your API service to fetch user data
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