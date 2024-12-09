
// part of 'auth_library.dart';


import 'package:bookly/core/dio_helper.dart';
import 'package:bookly/features/auth/controller/sign_in_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  final DioHelper  _apiService; // Inject your API service

  SignInCubit(this._apiService) : super(SignInInitialState());

  // Method to handle sign-in logic
  Future<void> signIn(String email, String password) async {
    emit(SignInLoadingState()); // Emit loading state when the sign-in process starts

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

  // Method to handle user retrieval logic
  Future<void> _getUser() async {
    emit(GetUserLoadingState()); // Emit loading state when fetching user data

    try {
      // Call your API service to fetch user data
      final user = await _apiService.getUserData();

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

extension on Map<String, dynamic> {
  bool? get success => null;
}
