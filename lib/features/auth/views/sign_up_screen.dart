import 'package:bookly/core/colors_app.dart';
import 'package:bookly/core/text_style.dart';
import 'package:bookly/features/auth/controller/sign_up_cubit.dart';
import 'package:bookly/features/auth/controller/sign_up_state.dart';
import 'package:bookly/features/auth/widgets/buttton.dart';
import 'package:bookly/features/auth/widgets/form_firld.dart';
import 'package:bookly/features/home/views/home_page.dart';
import 'package:bookly/features/summrize/views/summary_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dio_helper.dart';
class SignUpView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit,SignUpState>(
        listener: (BuildContext context, SignUpState state) {
          if(state is SignUpSuccessState)
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
        },
        builder: (BuildContext context, SignUpState state) {
          var cubit = context.read<SignUpCubit>();

          return Scaffold(
            backgroundColor: ColorStyles.backgroundColor,
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                              text: TextSpan(text: 'H', style: TextStyles.richTextStyle)),
                          Text(
                            'ello!',
                            style: TextStyles.headerStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Signup to get started',
                          style:  TextStyles.subHeaderStyle
                      ),
                      SizedBox(height: 24),
                      customTextFormField(
                        hint: "Name",
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      customTextFormField(
                        hint: "Email Address",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty";
                          }
                          if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      customTextFormField(
                        hint: "Phone",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      customTextFormField(
                        hint: "Password",
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters long";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: customButton(
                          text: "Signup",
                          onPressed: () {
                            cubit.signUp(nameController.text,  passwordController.text, emailController.text,phoneController.text);

                            print("Sign up clicked!");
                          },
                          color: ColorStyles
                              .buttonColor, // Replace with `ColorStyles.buttonColor`
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Add sign-in navigation logic here
                            print("Navigate to Sign in");
                          },
                          child: Text('Already have an account? Sign in',
                              style: TextStyles.subHeaderStyle),
                        ),
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
