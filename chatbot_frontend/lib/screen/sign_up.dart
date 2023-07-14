
import 'dart:io';

import 'package:chatbot_frontend/helper/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/routes.dart';
import '../constants.dart';
import '../providers/user_provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _fomKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordInputVisibilityNotifier =
      ValueNotifier(false);
  final ValueNotifier<bool> confirmPasswordInputVisibilityNotifier =
      ValueNotifier(false);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ValueNotifier<File?> imageNotifier = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Create an account",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: 440,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 5),
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                spreadRadius: 1,
                                blurRadius: 8)
                          ]),
                      child: Form(
                        key: _fomKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 34,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 24),
                              child: TextFormField(
                                controller: nameController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your name";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  nameController.text = value!;
                                },
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    hintStyle: TextStyle(
                                        color: Color(0xffBDBDBD),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    filled: true,
                                    fillColor: Color(0xffF5F5F5),
                                    hintText: "Enter your full name*",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 24),
                              child: TextFormField(
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)) {
                                    return "Please enter a valid email address";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  emailController.text = value!;
                                },
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    hintStyle: TextStyle(
                                        color: Color(0xffBDBDBD),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    filled: true,
                                    fillColor: Color(0xffF5F5F5),
                                    hintText: "Enter your email ID*",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor))),
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable:
                                    passwordInputVisibilityNotifier,
                                builder: (context, _, __) {
                                  return PasswordInputForm(
                                    controller: passwordController,
                                    hintText: "Enter password",
                                    last: false,
                                    isHidden:
                                        passwordInputVisibilityNotifier.value,
                                    onTogglePress: () =>
                                        passwordInputVisibilityNotifier.value =
                                            !passwordInputVisibilityNotifier
                                                .value,
                                  );
                                }),
                            ValueListenableBuilder(
                                valueListenable:
                                    confirmPasswordInputVisibilityNotifier,
                                builder: (context, _, __) {
                                  return PasswordInputForm(
                                    controller: confirmPasswordController,
                                    hintText: "Confirm password",
                                    last: true,
                                    isHidden:
                                        confirmPasswordInputVisibilityNotifier
                                            .value,
                                    onTogglePress: () =>
                                        confirmPasswordInputVisibilityNotifier
                                                .value =
                                            !confirmPasswordInputVisibilityNotifier
                                                .value,
                                  );
                                }),
                            const SizedBox(
                              height: 28,
                            ),
                            InkWell(
                              onTap: () async {
                                await validation(context);
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0xff333333)),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.popAndPushNamed(context, rSignIn);
                                  },
                                  child: const Text(
                                    " Sign In",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future validation(BuildContext context) async {
    final isValid = _fomKey.currentState!.validate();
    if (isValid && passwordController.text == confirmPasswordController.text) {
      _fomKey.currentState!.save();
      Loading.show(context);
      final userProvider = context.read<UserProvider>();
      await userProvider
          .signUp(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      )
          .then((value) {
        Loading.dismiss(context);
        if (value) {
          Navigator.pushNamed(context, rEmailVerification,
              arguments: emailController.text);
        } else {
          showErrorMessage(context);
        }
      });
    } else if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Password does not match",
            style: TextStyle(color: Colors.white),
          )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Please fill all the fields",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  void showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Something went wrong! Please try again"),
      backgroundColor: kPrimaryColor,
    ));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h - 220);
    path.quadraticBezierTo(0, h - 180, 40, h - 160);
    path.lineTo(w - 40, h - 20);
    path.quadraticBezierTo(w, h, w, h - 60);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({super.key, required this.isChecked});
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 18,
      decoration:
          BoxDecoration(border: Border.all(width: 1.3, color: kPrimaryColor)),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          color: isChecked ? kPrimaryColor : Colors.white,
        ),
      ),
    );
  }
}

class PasswordInputForm extends StatelessWidget {
  const PasswordInputForm(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.last,
      required this.isHidden,
      required this.onTogglePress});

  final String hintText;
  final bool last;
  final bool isHidden;
  final VoidCallback onTogglePress;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: last ? 8 : 24),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter password";
          } else if (value.length < 8) {
            return "Password must be at least 8 characters";
          }
          return null;
        },
        onSaved: (value) {
          controller.text = value!;
        },
        obscureText: !isHidden,
        obscuringCharacter: "*",
        style: const TextStyle(letterSpacing: 5),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          suffixIcon: isHidden
              ? InkWell(
                  onTap: onTogglePress,
                  child: const Icon(
                    Icons.visibility,
                    color: kPrimaryColor,
                  ))
              : InkWell(
                  onTap: onTogglePress,
                  child: const Icon(
                    Icons.visibility_off,
                    color: kPrimaryColor,
                  ),
                ),
          hintStyle: const TextStyle(
              color: Color(0xffBDBDBD),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2),
          filled: true,
          fillColor: const Color(0xffF5F5F5),
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
        ),
      ),
    );
  }
}
