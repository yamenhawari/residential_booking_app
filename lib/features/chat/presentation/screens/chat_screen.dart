import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final int conversationId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    String? otherUserImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
