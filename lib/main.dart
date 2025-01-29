import 'package:bookly/core/dio_helper.dart';
import 'package:bookly/features/auth/controller/sign_in_cubit.dart';
import 'package:bookly/features/libaray/controller/libaray_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app_routes.dart';
import 'core/bloc_obosever.dart';
import 'core/routes.dart';
import 'features/auth/controller/sign_up_cubit.dart';
import 'features/summrize/controller/summary_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  Bloc.observer = MyBlocObserver();
  DioHelper.internal();
  runApp( Bookly());
  FlutterNativeSplash.remove();

}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Page'),
      ),
      body: const Center(
        child: Text('Welcome to My Home Page!'),
      ),
    );
  }
}

class Bookly extends StatelessWidget {
   Bookly({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider(create: (context)=> SignUpCubit(),),
        BlocProvider(create: (context)=> SignInCubit(),),
        BlocProvider(create: (context)=> SummaryCubit(),),
        BlocProvider(create: (context)=> LibarayCubit()..getBooks(),),


      ],
      child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              onGenerateRoute: AppRouter.onGenerateRoute,
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.login,
            );
          }),
    );
  }
}

