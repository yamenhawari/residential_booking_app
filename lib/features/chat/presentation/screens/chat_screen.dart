import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/datasources/user_local_data_source.dart';
import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/models/user_model.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/services/notification_service.dart';
import 'package:residential_booking_app/core/utils/app_dialogs.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/widgets/custom_error_widget.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/features/chat/domain/entities/message.dart';
import 'package:residential_booking_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:residential_booking_app/features/chat/presentation/cubit/chat_state.dart';
import 'package:residential_booking_app/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:residential_booking_app/features/chat/presentation/widgets/chat_input_area.dart';
import 'package:residential_booking_app/features/chat/presentation/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final int conversationId;
  final String otherUserName;
  final String? otherUserImage;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    this.otherUserImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<int> _selectedMessageIds = {};

  bool get _isSelectionMode => _selectedMessageIds.isNotEmpty;
  int _currentUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    context.read<ChatCubit>().enterChat(widget.conversationId);
    NotificationService.currentActiveConversationId = widget.conversationId;
  }

  Future<void> _loadCurrentUser() async {
    try {
      final UserModel user = await sl<UserLocalDataSource>().getUser();
      if (mounted) {
        setState(() {
          _currentUserId = user.id;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    context.read<ChatCubit>().stopPollingMessages();
    NotificationService.currentActiveConversationId = null;
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(
          widget.conversationId,
          _textController.text.trim(),
          _currentUserId,
        );
    _textController.clear();
    _scrollToBottom();
  }

  void _toggleSelection(int messageId, int senderId) {
    if (senderId != _currentUserId) return;
    setState(() {
      if (_selectedMessageIds.contains(messageId)) {
        _selectedMessageIds.remove(messageId);
      } else {
        _selectedMessageIds.add(messageId);
      }
    });
  }

  void _deleteSelectedMessages() {
    AppDialogs.showConfirm(
      context,
      title: context.tr.deleteSelectedTitle,
      // FIX: Called as a function passing the count
      message: context.tr.deleteSelectedContent(_selectedMessageIds.length),
      onConfirm: () {
        for (var id in _selectedMessageIds) {
          context.read<ChatCubit>().deleteMessage(id, widget.conversationId);
        }
        setState(() => _selectedMessageIds.clear());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ChatAppBar(
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedMessageIds.length,
        otherUserName: widget.otherUserName,
        otherUserImage: widget.otherUserImage,
        conversationId: widget.conversationId,
        onClearSelection: () => setState(() => _selectedMessageIds.clear()),
        onDelete: _deleteSelectedMessages,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              buildWhen: (previous, current) =>
                  current is MessagesLoaded ||
                  current is ChatLoading ||
                  current is ChatInitial ||
                  current is MessageSending ||
                  current is ChatError,
              builder: (context, state) {
                if (state is ChatInitial ||
                    (state is ChatLoading && state is! MessageSending)) {
                  return const LoadingWidget(color: AppColors.primary);
                }

                if (state is ChatError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context
                        .read<ChatCubit>()
                        .getMessages(widget.conversationId),
                  );
                }

                List<Message> messages = [];
                if (state is MessagesLoaded) {
                  messages = state.messages;
                } else if (state is MessageSending) {
                  messages = state.messages;
                }

                if (messages.isEmpty) {
                  return _buildEmptyState();
                }

                final reversedMessages = messages.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final message = reversedMessages[index];
                    final bool isMe = message.senderId == _currentUserId;

                    return MessageBubble(
                      key: ValueKey(message.id),
                      message: message,
                      isMe: isMe,
                      isSelected: _selectedMessageIds.contains(message.id),
                      otherUserImage: widget.otherUserImage,
                      onTap: () {
                        if (_isSelectionMode) {
                          _toggleSelection(message.id, message.senderId);
                        }
                      },
                      onLongPress: () {
                        HapticFeedback.mediumImpact();
                        _toggleSelection(message.id, message.senderId);
                      },
                    );
                  },
                );
              },
            ),
          ),
          ChatInputArea(
            controller: _textController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.waving_hand, size: 40.sp, color: Colors.orange),
          SizedBox(height: 10.h),
          Text(context.tr.sayHello,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
