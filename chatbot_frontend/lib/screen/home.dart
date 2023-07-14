import 'dart:async';
import 'dart:math';

import 'package:chatbot_frontend/config/routes.dart';
import 'package:chatbot_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../modals/book.dart';
import '../modals/user.dart';

class HomeScreen extends StatefulWidget {
  final User userData;
  const HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<Book> books = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
      getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Hello, ${widget.userData.name}"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, rProfile);
              },
              icon: Icon(
                Icons.people,
              ))
        ],
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, rChatScreen);
                      },
                      child: Container(
                        height: 120,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 5),
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ]),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.chat,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Chat with Pixie",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, rStoryScreen);
                      },
                      child: Container(
                        height: 120,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 5),
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ]),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.menu_book_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Storytime with Pixie",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                      onChanged: (value) async {
                        books = await context
                            .read<UserProvider>()
                            .getAllBook(value);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Search with title or keywords",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.blue,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Books",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return BookTile(book: books[index]);
                    },
                  ),
                )
              ],
            ),
    );
  }

  FutureOr setData() async {
    final user = context.read<UserProvider>();
    user.setUser(widget.userData);
  }

  Future getData() async {
    isLoading = true;
    setState(() {});
    books = await context.read<UserProvider>().getAllBook(null);
    isLoading = false;
    setState(() {});
  }
}

class BookTile extends StatelessWidget {
  final Book book;
  const BookTile({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, rBookDetails, arguments: {
          "book": book,
          "myBook": false,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(
              "assets/book/${Random().nextInt(10) % 10 + 1}.png",
              height: 40,
              width: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(book.owner,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
