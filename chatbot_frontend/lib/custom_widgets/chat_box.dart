import 'package:flutter/material.dart';

import '../modals/message.dart';

class ChatBox extends StatelessWidget {
  final Role role;
  final String message;
  const ChatBox({
    required this.role,
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: (role == Role.assistant)
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Padding(
              padding: (role == Role.user)
                  ? const EdgeInsets.only(left: 20)
                  : const EdgeInsets.only(right: 20),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: (role == Role.user) ? Colors.blue : Colors.blueGrey,
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]);
  }
}
