import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../modals/message.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String signInUrl = 'auth_server/api/v1/user/login';
  static const String signUpUrl = 'auth_server/api/v1/user';
  static const String verifyUrl = 'pdf_server/api/v1/user/verify';
  static const String userBooksUrl = 'pdf_server/api/v1/pdf/user';
  static const String getReplyUrl = 'bot_server/api/v1/getreply';
  static const String generatePDFUrl = 'bot_server/api/v1/pdf';
  static const String deleteBookUrl = 'pdf_server/api/v1/pdf/book';
  static const String shareBookUrl = 'pdf_server/api/v1/pdf/share';
  static const String getAllBooksUrl = 'pdf_server/api/v1/pdf';
  static Future getReply(List<Message> messages) async {
    final map = messages.map((e) => e.toJson()).toList();

    var response = await http.post(
      Uri.parse("$api_path/$getReplyUrl"),
      body: jsonEncode({
        "messages": map,
        "isStory": false,
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await getToken()}",
      },
    );

    return jsonDecode(response.body);
  }

  static Future getStoryReply(List<Message> messages) async {
    final map = messages.map((e) => e.toJson()).toList();

    var response = await http.post(
      Uri.parse("$api_path/$getReplyUrl"),
      body: jsonEncode({
        "messages": map,
        "isStory": true,
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await getToken()}"
      },
    );

    return jsonDecode(response.body);
  }

  static Future signIn({required Map<String, dynamic> body}) async {
    var response = await http.post(
      Uri.parse("$api_path/$signInUrl"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    log(response.body);
    return jsonDecode(response.body);
  }

  static Future signUp({required Map<String, dynamic> body}) async {
    var response = await http.post(
      Uri.parse("$api_path/$signUpUrl"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }

  static Future verifyUser({required Map<String, dynamic> body}) async {
    var response = await http.post(
      Uri.parse("$api_path/$verifyUrl"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }

  static Future getUserBooks(String id) async {
    var response = await http.get(
      Uri.parse("$api_path/$userBooksUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await getToken()}",
      },
    );
    log(response.body);
    return jsonDecode(response.body);
  }

  static Future generatePDF(String message) async {
    var response = await http.post(
      Uri.parse("$api_path/$generatePDFUrl"),
      body: jsonEncode({
        "story": message,
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await getToken()}",
      },
    );
    log(response.body);
    return jsonDecode(response.body);
  }

  static Future deleteBook(String id) async {
    var response =
        await http.delete(Uri.parse("$api_path/$deleteBookUrl/$id"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await getToken()}",
    });

    return jsonDecode(response.body);
  }

  static Future shareBook(String id) async {
    var response = await http.post(
      Uri.parse("$api_path/$shareBookUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await getToken()}",
      },
    );

    return jsonDecode(response.body);
  }

  static Future getAllBooks(String? query) async {
    var response = await http.get(
      (query == null)
          ? Uri.parse("$api_path/$getAllBooksUrl")
          : Uri.parse("$api_path/$getAllBooksUrl?q=$query"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await getToken()}",
      },
    );
  
    return jsonDecode(response.body);
  }
}

getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
