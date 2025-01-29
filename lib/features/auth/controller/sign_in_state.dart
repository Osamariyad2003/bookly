

abstract class SignInState {}

 class SignInInitialState extends SignInState{

 }
class SignInLoadingState extends SignInState{

}

class SignInSuccessState extends SignInState{

}

class SignInErrorState extends SignInState{
 final String e;
 SignInErrorState(this.e);
}

class GetUserLoadingState extends SignInState{

}
class GetUserSuccessState extends SignInState{

}

class GetUserErrorState extends SignInState{
 final String error;
 GetUserErrorState(this.error);
}