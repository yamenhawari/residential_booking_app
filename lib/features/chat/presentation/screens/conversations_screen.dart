import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/widgets/custom_error_widget.dart';
import 'package:residential_booking_app/core/widgets/loading_widget.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.messagesTitle,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp),
          onPressed: () => sl<NavigationService>().goBack(),
        ),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (previous, current) =>
            current is ConversationsLoaded ||
            current is ChatLoading ||
            current is ChatError,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingWidget(color: AppColors.primary);
          }

          if (state is ChatError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<ChatCubit>().loadConversations(),
            );
          }

          if (state is ConversationsLoaded) {
            if (state.conversations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.chat_bubble_outline_rounded,
                          size: 40.sp, color: theme.disabledColor),
                    ),
                    SizedBox(height: 16.h),
                    Text(localizations.noMessagesYet,
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: state.conversations.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final chat = state.conversations[index];
                final bool hasUnread = chat.unreadCount > 0;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Dismissible(
                    key: Key(chat.id.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(localizations.deleteChatTitle),
                            content: Text(localizations.deleteChatContent),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(localizations.no),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                  localizations.yes,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 24.w),
                      color: AppColors.error,
                      child: Icon(Icons.delete_outline,
                          color: Colors.white, size: 24.sp),
                    ),
                    onDismissed: (direction) {
                      context.read<ChatCubit>().deleteConversation(chat.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: hasUnread
                            ? AppColors.primary.withOpacity(0.08)
                            : theme.cardColor,
                        border: hasUnread
                            ? Border(
                                left: BorderSide(
                                    color: AppColors.primary, width: 4.w))
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        onTap: () {
                          sl<NavigationService>().pushNamed(
                            AppRoutes.chat,
                            arguments: {
                              'conversationId': chat.id,
                              'otherUserName': chat.otherUserName,
                              'otherUserImage': chat.otherUserImage,
                            },
                          );
                        },
                        leading: Hero(
                          tag: 'avatar_${chat.id}',
                          child: Stack(
                            children: [
                              Container(
                                width: 50.r,
                                height: 50.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: theme.dividerColor, width: 1),
                                  image: chat.otherUserImage != null
                                      ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              chat.otherUserImage!),
                                          fit: BoxFit.cover)
                                      : null,
                                ),
                                child: chat.otherUserImage == null
                                    ? Icon(Icons.person,
                                        color: Colors.grey[400], size: 24.sp)
                                    : null,
                              ),
                              if (hasUnread)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 14.w,
                                    height: 14.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: theme.cardColor, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chat.otherUserName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: hasUnread
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            if (chat.lastMessageTime.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Text(
                                  timeago.format(
                                      DateTime.parse(chat.lastMessageTime),
                                      locale: 'en_short'),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11.sp,
                                    color: hasUnread
                                        ? AppColors.primary
                                        : theme.disabledColor,
                                    fontWeight: hasUnread
                                        ? FontWeight.w800
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            chat.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              fontWeight: hasUnread
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              color: hasUnread
                                  ? theme.textTheme.bodyLarge?.color
                                  : theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.8),
                            ),
                          ),
                        ),
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
