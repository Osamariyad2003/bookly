import 'package:bookly/core/colors_app.dart';
import 'package:bookly/core/routes.dart';
import 'package:bookly/core/text_style.dart';
import 'package:bookly/features/auth/controller/sign_in_cubit.dart';
import 'package:bookly/features/auth/controller/sign_in_state.dart';
import 'package:bookly/features/auth/widgets/buttton.dart';
import 'package:bookly/features/auth/widgets/form_firld.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      builder: (BuildContext context, SignInState state) {
        return Scaffold(
          backgroundColor: ColorStyles.backgroundColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: 'W', style: TextStyles.richTextStyle)),
                      Text(
                        'elcome',
                        style: TextStyles.headerStyle,
                      ),
                      Text('Back!', style: TextStyles.headerStyle),
                    ],
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
                  SizedBox(height: 16),
                  Center(
                    child: customButton(
                      text: "SignIn",
                      onPressed: () {
                        print("Sign in clicked!");
                      },
                      color: ColorStyles
                          .buttonColor, // Replace with `ColorStyles.buttonColor`
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.register);
                        print("Navigate to Sign in");
                      },
                      child: Text('Already have an account? Sign Up',
                          style: TextStyles.subHeaderStyle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, SignInState state) {},
    );
  }
}
