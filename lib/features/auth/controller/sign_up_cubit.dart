//import 'package:bookly/features/auth/controller/sign_up_state.dart';
import 'package:bookly/features/auth/controller/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dio_helper.dart';
class SignUpCubit extends Cubit{

  final DioHelper  _apiService; // Inject your API service
  SignUpCubit(super.SignUpInitialState, this._apiService);

  Future<void> signUp(String name, String email,String password,String phoneNumber) async {
    emit(SignUpLoadingState()); // Emit loading state when the sign-in process starts

    try {
      // Call your API service to attempt signing in
      final result = await _apiService.signIn(email, password);

      if (result.success == true) {
        emit(SignInSuccessState()); // Emit success state on successful sign-in
        _getUser(); // Optionally fetch user data after successful sign-in
      } else {
        emit(SignInErrorState()); // Emit error state if sign-in fails
      }

    } catch (error) {
      emit(SignInErrorState()); // Emit error state in case of an exception
    }
  }

}