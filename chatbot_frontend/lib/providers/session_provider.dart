import 'package:chatbot_frontend/modals/message.dart';
import 'package:flutter/material.dart';

import '../config/api.dart';

class SessionProvider extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  Future getReply(String message) async {
    addMessage(Message(role: Role.user, content: message));
    Map<String, dynamic> reply = await Api.getReply(_messages);

    addMessage(Message(role: Role.assistant, content: reply['data']['reply']));
  }
}
