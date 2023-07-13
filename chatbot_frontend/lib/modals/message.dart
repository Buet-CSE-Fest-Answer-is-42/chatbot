enum Role { user, assistant }

class Message {
  final Role role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: stringToRole(json['role']),
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': roleToString(role),
      'content': content,
    };
  }
}

Role stringToRole(String role) {
  switch (role) {
    case 'user':
      return Role.user;
    case 'assistant':
      return Role.assistant;

    default:
      return Role.user;
  }
}

String roleToString(Role role) {
  switch (role) {
    case Role.user:
      return 'user';
    case Role.assistant:
      return 'assistant';
  }
}
