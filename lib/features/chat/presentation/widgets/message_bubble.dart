import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/chat/domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool isSelected;
  final String? otherUserImage;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isSelected,
    this.otherUserImage,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime? date;
    try {
      date = DateTime.parse(message.createdAt).toLocal();
    } catch (_) {}
    final timeStr = date != null ? DateFormat('hh:mm a').format(date) : "";

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // PROFILE PHOTO (Only for received messages)
            if (!isMe) ...[
              Container(
                width: 28.r,
                height: 28.r,
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.dividerColor,
                ),
                child: ClipOval(
                  child: otherUserImage != null && otherUserImage!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: otherUserImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Icon(
                            Icons.person,
                            size: 16.sp,
                            color: Colors.grey,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 16.sp,
                            color: Colors.grey,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                ),
              ),
            ],

            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 0.70.sw),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primary : theme.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: isMe ? Radius.circular(18.r) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : Radius.circular(18.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.body,
                      style: TextStyle(
                        color: isMe
                            ? Colors.white
                            : theme.textTheme.bodyLarge?.color,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white.withOpacity(0.7)
                                : theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.5),
                            fontSize: 10.sp,
                          ),
                        ),
                        if (isMe && message.isPending) ...[
                          SizedBox(width: 4.w),
                          Icon(Icons.access_time,
                              size: 10.sp,
                              color: Colors.white.withOpacity(0.8)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
