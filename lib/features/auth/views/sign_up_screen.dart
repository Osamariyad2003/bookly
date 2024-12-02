import 'package:bookly/core/colors_app.dart';
import 'package:bookly/core/text_style.dart';
import 'package:bookly/features/auth/widgets/buttton.dart';
import 'package:bookly/features/auth/widgets/form_firld.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(text: 'H', style: TextStyles.richTextStyle)),
              Text(
                'ello!',
                style: TextStyles.headerStyle,
              ),
              Text(
                'ello!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color:
                      Colors.black, // Replace with `WidgetStyles.headerStyle`
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Signup to get started',
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Colors.grey, // Replace with `WidgetStyles.subHeaderStyle`
                ),
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
                    // Add signup logic here
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
    );
  }
}
