import 'package:bookly/core/routes.dart';
import 'package:bookly/features/auth/views/sign_in_screen.dart';
import 'package:bookly/features/auth/views/sign_up_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.register:
        return MaterialPageRoute(
        builder: (_)=> SignUpView()
        );

      case Routes.login:
         return MaterialPageRoute(
            builder: (_)=> SignInView()
        );
      default:
        return MaterialPageRoute(
            builder: (_)=> SignInView()
        );



    // case Routes.home:
    //   return MaterialPageRoute(
    //       builder: (_) => BlocProvider(
    //             create: (context) => MealCubit(
    //                 fetchMealsUseCase: FetchMeals(
    //                     MealRepositoryImpl(FirebaseService(), LocalData())),
    //                 addMealToFavoritesUseCase: AddMealToFav(
    //                     MealRepositoryImpl(FirebaseService(), LocalData())),
    //                 removeFavoriteMealUseCase: RemoveMeal(
    //                     MealRepositoryImpl(FirebaseService(), LocalData())),
    //                 updateIsFavUseCase: UpdateIsFavInFirestore(
    //                     MealRepositoryImpl(FirebaseService(), LocalData())),
    //                 removeMealFromFirestore: RemoveMealFromFirestore(
    //                     MealRepositoryImpl(FirebaseService(), LocalData())),
    //                 localData: LocalData())
    //               ..fetchMeals(),
    //             child: const HomeScreen(),
    //           ))
    }
  }

}