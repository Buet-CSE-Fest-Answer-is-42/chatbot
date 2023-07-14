import 'dart:async';
import 'dart:developer';

import 'package:chatbot_frontend/modals/message.dart';
import 'package:flutter/material.dart';

import '../config/api.dart';

class SessionProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Message> _storyMessages = [];
  List<Message> get messages => _messages;
  List<Message> get storyMessages => _storyMessages;

  addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  addStoryMessage(Message message) {
    _storyMessages.add(message);
    notifyListeners();
  }

  FutureOr getReply(String message) async {
    addMessage(Message(role: Role.user, content: message));
    Map<String, dynamic> reply = await Api.getReply(_messages);

    addMessage(Message(role: Role.assistant, content: reply['data']['reply']));
  }

  Future getStory(String message) async {
    addStoryMessage(Message(role: Role.user, content: message));

    log(_storyMessages.last.content);

    Map<String, dynamic> reply = await Api.getStoryReply(_storyMessages);

    log(reply.toString());
    addStoryMessage(
        Message(role: Role.assistant, content: reply['data']['reply']));
  }

  Future<bool> generatePDF(String message) async {
    Map<String, dynamic> reply =  await Api.generatePDF(message);

    if(reply['status'] == 'success'){
      return true;
    }else{
      return false;
    }
  }
}
