import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_booking_app/core/usecases/usecase.dart';
import 'package:residential_booking_app/features/chat/domain/entities/message.dart';
import 'package:residential_booking_app/features/chat/domain/usecases/delete_chat_usecase.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/start_chat_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetConversationsUseCase getConversationsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final StartChatUseCase startChatUseCase;
  final DeleteConversationUseCase deleteConversationUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;

  Timer? _messagesTimer;
  Timer? _conversationsTimer;

  ChatCubit({
    required this.getConversationsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.startChatUseCase,
    required this.deleteConversationUseCase,
    required this.deleteMessageUseCase,
  }) : super(ChatInitial());

  void loadConversations() async {
    if (state is! ConversationsLoaded) emit(ChatLoading());
    final result = await getConversationsUseCase(NoParams());
    result.fold(
      (l) => emit(ChatError(l.message)),
      (r) => emit(ConversationsLoaded(r)),
    );
  }

  void startPollingConversations() {
    _conversationsTimer?.cancel();
    loadConversations();
    _conversationsTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final result = await getConversationsUseCase(NoParams());
      result.fold(
        (l) => null,
        (r) {
          if (!isClosed) emit(ConversationsLoaded(r));
        },
      );
    });
  }

  void stopPollingConversations() {
    _conversationsTimer?.cancel();
  }

  void startChat(int receiverId) async {
    emit(ChatLoading());
    final result = await startChatUseCase(receiverId);
    result.fold(
      (l) => emit(ChatError(l.message)),
      (r) => emit(ChatCreated(r)),
    );
  }

  void enterChat(int conversationId) {
    _messagesTimer?.cancel();
    emit(ChatLoading());
    getMessages(conversationId);
    startPollingMessages(conversationId);
  }

  void getMessages(int conversationId) async {
    final result = await getMessagesUseCase(conversationId);
    result.fold(
      (l) => emit(ChatError(l.message)),
      (r) => emit(MessagesLoaded(r)),
    );
  }

  void startPollingMessages(int conversationId) {
    _messagesTimer?.cancel();
    _messagesTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (state is! MessageSending && !isClosed) {
        getMessages(conversationId);
      }
    });
  }

  void stopPollingMessages() {
    _messagesTimer?.cancel();
  }

  void sendMessage(int conversationId, String body, int senderId) async {
    List<Message> currentMessages = [];

    if (state is MessagesLoaded) {
      currentMessages = (state as MessagesLoaded).messages;
    } else if (state is MessageSending) {
      currentMessages = (state as MessageSending).messages;
    }

    final tempMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      senderId: senderId,
      body: body,
      createdAt: DateTime.now().toIso8601String(),
      isPending: true,
    );

    final updatedList = List<Message>.from(currentMessages)..add(tempMessage);
    emit(MessageSending(updatedList));

    await sendMessageUseCase(SendMessageParams(conversationId, body));
    getMessages(conversationId);
  }

  void deleteConversation(int id) async {
    await deleteConversationUseCase(id);
    loadConversations();
  }

  void deleteMessage(int id, int conversationId) async {
    await deleteMessageUseCase(id);
    getMessages(conversationId);
  }

  @override
  Future<void> close() {
    _messagesTimer?.cancel();
    _conversationsTimer?.cancel();
    return super.close();
  }
}
