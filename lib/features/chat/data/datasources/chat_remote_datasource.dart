import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/core/api/api_constants.dart';
import 'package:residential_booking_app/core/api/api_consumer.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<List<MessageModel>> getMessages(int conversationId);
  Future<Unit> sendMessage(int conversationId, String body);
  Future<int> startChat(int receiverId);
  Future<Unit> deleteConversation(int id);
  Future<Unit> deleteMessage(int id);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiConsumer apiConsumer;

  ChatRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<ConversationModel>> getConversations() async {
    final response =
        await apiConsumer.get("${ApiConstants.baseUrl}/chat/conversations");
    final List data = response['data'];
    return data.map((e) => ConversationModel.fromJson(e)).toList();
  }

  @override
  Future<List<MessageModel>> getMessages(int conversationId) async {
    final response = await apiConsumer
        .get("${ApiConstants.baseUrl}/chat/$conversationId/messages");
    final List data = response['data'];
    return data.map((e) => MessageModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> sendMessage(int conversationId, String body) async {
    await apiConsumer.post("${ApiConstants.baseUrl}/chat/$conversationId/send",
        body: {'body': body});
    return unit;
  }

  @override
  Future<int> startChat(int receiverId) async {
    final response = await apiConsumer.post(
        "${ApiConstants.baseUrl}/chat/start",
        body: {'receiver_id': receiverId});
    return response['data']['id'];
  }

  @override
  Future<Unit> deleteConversation(int id) async {
    await apiConsumer.delete("${ApiConstants.baseUrl}/chat/conversations/$id");
    return unit;
  }

  @override
  Future<Unit> deleteMessage(int id) async {
    await apiConsumer.delete("${ApiConstants.baseUrl}/chat/messages/$id");
    return unit;
  }
}
