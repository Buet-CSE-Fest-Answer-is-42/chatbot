import 'dart:async';
import 'dart:math';

import 'package:chatbot_frontend/config/routes.dart';
import 'package:chatbot_frontend/constants.dart';
import 'package:chatbot_frontend/modals/book.dart';
import 'package:chatbot_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Book> books = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmDialog();
                      });
                },
                icon: Icon(Icons.logout, color: Color(0xff333333)))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: kPrimaryColor,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff333333),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Saved Books",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return BookContainer(
                          book: books[index],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  FutureOr getData() async {
    books = await context.read<UserProvider>().getUserBooks();
    setState(() {});
  }
}

class BookContainer extends StatelessWidget {
  const BookContainer({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, rBookDetails, arguments: {
        "book": book,
        "myBook": true,
      }),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 5),
                color: Color.fromRGBO(0, 0, 0, 0.3),
                spreadRadius: 1,
                blurRadius: 8)
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              "assets/book/${Random().nextInt(10) % 10 + 1}.png",
              height: 80,
              width: 80,
            ),
            SizedBox(
              height: 15,
            ),
            Text(book.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ))
          ],
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Are you sure?",
        ),
        content: const Text(
          "Do you want to logout?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
            ),
          ),
          TextButton(
            onPressed: () async {
              await context.read<UserProvider>().signOut().then((value) =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, rSignIn, (route) => false));
            },
            child: const Text(
              "Logout",
            ),
          )
        ]);
  }
}
