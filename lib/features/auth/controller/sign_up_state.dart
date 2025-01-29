//part of "sign_in_cubit.dart";

abstract class SignUpState {}

class SignUpInitialState extends SignUpState{

}
class SignUpErrorState extends SignUpState{

}

class SignUpLoadingState extends SignUpState{

}

class SignUpSuccessState extends SignUpState{

}


class GetUserLoadingState extends SignUpState{

}
class GetUserSuccessState extends SignUpState{

}

class GetUserErrorState extends SignUpState{
  final String error;
  GetUserErrorState(this.error);
}