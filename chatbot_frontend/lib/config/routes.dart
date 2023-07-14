import 'package:chatbot_frontend/screen/email_verification.dart';
import 'package:chatbot_frontend/screen/sign_in.dart';
import 'package:chatbot_frontend/screen/sign_up.dart';
import 'package:flutter/material.dart';

import '../modals/book.dart';
import '../modals/user.dart';
import '../screen/book_details.dart';
import '../screen/chat_screen.dart';
import '../screen/home.dart';
import '../screen/profile.dart';

const String rChatScreen = 'chat_screen';
const String rStoryScreen = 'story_screen';
const String rSignIn = 'sign_in';
const String rSignUp = 'sign_up';
const String rEmailVerification = 'email_verification';
const String rProfile = 'profile';
const String rHome = 'home';
const String rBookDetails = 'book_details';

class Routes {
  static Route<dynamic> genrateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case rChatScreen:
        return MaterialPageRoute(
          builder: (context) => const ChatScreen(
            isStory: false,
          ),
        );
      case rStoryScreen:
        return MaterialPageRoute(
            builder: (context) => const ChatScreen(
                  isStory: true,
                ));
      case rSignUp:
        return MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        );
      case rEmailVerification:
        return MaterialPageRoute(
          builder: (context) => EmailVerificationPage(
            email: args as String,
          ),
        );
      case rSignIn:
        return MaterialPageRoute(
          builder: (context) => SignInScreen(),
        );
      case rProfile:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );
      case rHome:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(
            userData: args as User,
          ),
        );
      case rBookDetails:
      final map = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BookDetails(
            book: map['book'],
            myBook: map['myBook'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => SignInScreen(),
        );
    }
  }
}
