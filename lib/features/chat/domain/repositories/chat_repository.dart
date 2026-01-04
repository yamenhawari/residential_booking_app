import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/core/error/failures.dart';
import 'package:residential_booking_app/features/chat/domain/entities/conversation.dart';
import 'package:residential_booking_app/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Conversation>>> getConversations();
  Future<Either<Failure, List<Message>>> getMessages(int conversationId);
  Future<Either<Failure, Unit>> sendMessage(int conversationId, String body);
  Future<Either<Failure, int>> startChat(int receiverId);
  Future<Either<Failure, Unit>> deleteConversation(int id);
  Future<Either<Failure, Unit>> deleteMessage(int id);
}
