import 'package:chatbot_frontend/config/routes.dart';
import 'package:chatbot_frontend/helper/loading_widget.dart';
import 'package:chatbot_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../constants.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;
  EmailVerificationPage({super.key, required this.email});

  final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "We have sent a 4 digit code to ${obscureEmail(email)}.\nPlease enter the code below",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Pinput(
            controller: _otpController,
            closeKeyboardWhenCompleted: true,
            onCompleted: (value) => verify(context, value),
          )
        ],
      ),
    );
  }

  FutureOr verify(
    BuildContext context,
    String value,
  ) async {
    Loading.show(context);
    await context.read<UserProvider>().verify(otp: value).then((value) {
      Loading.dismiss(context);
      if (value) {
        Navigator.pushNamedAndRemoveUntil(context, rSignIn, (route) => false);
      } else {
        showErrorMessage(context);
      }
    });
  }

  void showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Something went wrong! Please try again"),
      backgroundColor: kPrimaryColor,
    ));
  }

  String obscureEmail(String email) {
    int index = email.indexOf('@');
    String firstPart = email.substring(0, index);
    String secondPart = email.substring(index);
    if (firstPart.length > 3) {
      firstPart = '${firstPart.substring(0, 3)}***';
    }
    return firstPart + secondPart;
  }
}
