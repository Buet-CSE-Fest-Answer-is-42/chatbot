import 'dart:developer';

import 'package:chatbot_frontend/screen/home.dart';
import 'package:chatbot_frontend/screen/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/routes.dart';
import 'modals/user.dart';
import 'providers/session_provider.dart';
import 'providers/user_provider.dart';
import 'screen/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  bool loggedIn = false;
  User? user;
  if (token != null) {
    final data = JwtDecoder.decode(token);
    user = User(
      id: data['id'],
      name: data['name'],
      email: data['email'],
    );
    DateTime expiryDate = JwtDecoder.getExpirationDate(token);
    if (DateTime.now().isBefore(expiryDate)) {
      loggedIn = true;
    }
  }
  runApp(MyApp(
    loggedIn: loggedIn,
    userData: user,
  ));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  final User? userData;

  const MyApp({super.key, required this.loggedIn, this.userData});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SessionProvider(),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Pixies',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Routes.genrateRoute,
        home: loggedIn ? HomeScreen(
          userData: userData!,
        ): SignInScreen(),
      ),
    );
  }
}
