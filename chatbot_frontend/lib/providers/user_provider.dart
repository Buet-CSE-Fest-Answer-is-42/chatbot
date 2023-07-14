import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api.dart';
import '../modals/book.dart';
import '../modals/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User get user => _user!;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    final map = {
      "email": email,
      "password": password,
    };
    Map<String, dynamic> response = await Api.signIn(body: map);
    if (response['status'] == 'success') {
      await saveToken(response['token']);
      //await saveUserDetails(response['user'])
      setUser(User.fromJson(response['user']));
      return true;
    } else {
      return false;
    }
  }

  Future saveToken(token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<bool> signUp(
      {required String email,
      required String password,
      required String name}) async {
    final map = {
      "email": email,
      "password": password,
      "name": name,
    };
    Map<String, dynamic> response = await Api.signUp(body: map);
    if (response['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verify({required String otp}) async {
    final map = {
      "otp": otp,
    };

    Map<String, dynamic> response = await Api.verifyUser(body: map);
    if (response['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }

  Future signOut() async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
    });
  }

  Future<List<Book>> getUserBooks() async {
    Map<String, dynamic> response = await Api.getUserBooks(_user!.id);

    List<Book> books = [];
    if (response['pdfs'] != null) {
      books = List<Book>.from(response['pdfs'].map((e) => Book.fromJson(e)));
    }

    return books;
  }

  Future deleteBook({required String id}) async {
    Map<String, dynamic> response = await Api.deleteBook(id);
  }

  Future shareBook({required String id}) async {
    Map<String, dynamic> response = await Api.shareBook(id);
  }

  Future<List<Book>> getAllBook(String? query) async {
    Map<String, dynamic> response = await Api.getAllBooks(query);
    List<Book> books = [];
    if (response['pdfs'] != null) {
      books = List<Book>.from(response['pdfs'].map((e) => Book.fromJson(e)));
    }

    return books;
  }
}
