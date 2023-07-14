import 'dart:async';
import 'dart:developer';

import 'package:chatbot_frontend/config/routes.dart';
import 'package:chatbot_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../helper/loading_widget.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final ValueNotifier<bool> passwordInputVisibilityNotifier =
      ValueNotifier(false);

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                height: 550,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 140,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Sign In",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 38, horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(children: [
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your email";
                                }
                                return null;
                              },
                              onSaved: (newValue) =>
                                  emailController.text = newValue!,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                hintStyle: TextStyle(
                                    color: Color(0xffBDBDBD),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                hintText: "Enter your email*",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            ValueListenableBuilder(
                              valueListenable: passwordInputVisibilityNotifier,
                              builder: (context, _, __) {
                                return PasswordInputForm(
                                    controller: passwordController,
                                    hintText: "Password*",
                                    isHidden:
                                        passwordInputVisibilityNotifier.value,
                                    onTogglePress: () =>
                                        passwordInputVisibilityNotifier.value =
                                            !passwordInputVisibilityNotifier
                                                .value);
                              },
                            ),
                            const SizedBox(
                              height: 18,
                            ),

                            // InkWell(
                            //   onTap: () {
                            //     Navigator.pushNamed(
                            //         context, forgotPasswordRoute);
                            //   },
                            //   child: const Text(
                            //     "Forgot Password?",
                            //     style: TextStyle(
                            //       color: kPrimaryColor,
                            //       fontWeight: FontWeight.w500,
                            //       fontSize: 12,
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 30,
                            // ),
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
                                    "Go!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Do not have any account? ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff333333),
                                      fontSize: 12),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.popAndPushNamed(context, rSignUp);
                                  },
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: kPrimaryColor),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  FutureOr validation(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Loading.show(context);

      context
          .read<UserProvider>()
          .signIn(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((value) {
        Loading.dismiss(context);
        if (value) {
          Navigator.popAndPushNamed(context, rHome,
              arguments: context.read<UserProvider>().user);
        } else {
          showErrorMessage(context);
        }
      });
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

class PasswordInputForm extends StatelessWidget {
  const PasswordInputForm(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isHidden,
      required this.onTogglePress});

  final String hintText;
  final bool isHidden;
  final VoidCallback onTogglePress;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
      onSaved: (newValue) => controller.text = newValue!,
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
        fillColor: Color(0xffF5F5F5),
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor)),
      ),
    );
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
