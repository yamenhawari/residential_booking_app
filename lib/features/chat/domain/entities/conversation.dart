import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final int id;
  final int otherUserId;
  final String otherUserName;
  final String? otherUserImage;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        otherUserId,
        otherUserName,
        lastMessage,
        lastMessageTime,
        unreadCount
      ];
}
