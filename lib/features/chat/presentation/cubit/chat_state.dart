import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/features/chat/domain/entities/conversation.dart';
import 'package:residential_booking_app/features/chat/domain/entities/message.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ConversationsLoaded extends ChatState {
  final List<Conversation> conversations;
  ConversationsLoaded(this.conversations);
  @override
  List<Object> get props => [conversations];
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
  @override
  List<Object> get props => [messages];
}

class MessageSending extends ChatState {
  final List<Message> messages;
  MessageSending(this.messages);
  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
  @override
  List<Object> get props => [message];
}

class ChatCreated extends ChatState {
  final int conversationId;
  ChatCreated(this.conversationId);
  @override
  List<Object> get props => [conversationId];
}
