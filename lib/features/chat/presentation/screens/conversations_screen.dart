import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'chat_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().startPollingConversations();
  }

  @override
  void dispose() {
    context.read<ChatCubit>().stopPollingConversations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Messages"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (previous, current) =>
            current is ConversationsLoaded || current is ChatLoading,
        builder: (context, state) {
          if (state is ChatLoading) return const LoadingWidget();

          if (state is ConversationsLoaded) {
            if (state.conversations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 60.sp, color: Colors.grey[300]),
                    SizedBox(height: 16.h),
                    Text("No conversations yet",
                        style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final chat = state.conversations[index];

                return Dismissible(
                  key: Key(chat.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    context.read<ChatCubit>().deleteConversation(chat.id);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          )
                        ]),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                      conversationId: chat.id,
                                      otherUserName: chat.otherUserName,
                                      otherUserImage: chat.otherUserImage,
                                    )));
                      },
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      leading: CircleAvatar(
                        radius: 28.r,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: chat.otherUserImage != null
                            ? CachedNetworkImageProvider(chat.otherUserImage!)
                            : null,
                        child: chat.otherUserImage == null
                            ? Icon(Icons.person, color: Colors.grey[400])
                            : null,
                      ),
                      title: Text(chat.otherUserName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.grey[600]),
                        ),
                      ),
                      trailing: Text(
                        chat.lastMessageTime.isNotEmpty
                            ? timeago.format(
                                DateTime.parse(chat.lastMessageTime),
                                locale: 'en_short')
                            : "",
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
