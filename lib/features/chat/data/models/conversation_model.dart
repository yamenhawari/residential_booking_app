import '../../domain/entities/conversation.dart';
import 'package:residential_booking_app/core/api/api_constants.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.otherUserId,
    required super.otherUserName,
    super.otherUserImage,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    String? img;
    if (json['other_user_image'] != null) {
      img = "${ApiConstants.storageBaseUrl}${json['other_user_image']}";
    }

    return ConversationModel(
      id: json['id'],
      otherUserId: json['other_user_id'],
      otherUserName: json['other_user_name'],
      otherUserImage: img,
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}
