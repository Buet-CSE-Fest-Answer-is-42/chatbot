import 'dart:convert';

import '../constants.dart';
import '../modals/message.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future getReply(List<Message> messages) async {
    final map = messages.map((e) => e.toJson()).toList();

    var response = await http.post(
      Uri.parse("$api_path/getreply"),
      body: jsonEncode({
        "messages": map,
      }),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
