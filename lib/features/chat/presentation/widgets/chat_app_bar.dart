import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSelectionMode;
  final int selectedCount;
  final String otherUserName;
  final String? otherUserImage;
  final int conversationId;
  final VoidCallback onClearSelection;
  final VoidCallback onDelete;

  const ChatAppBar({
    super.key,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.otherUserName,
    this.otherUserImage,
    required this.conversationId,
    required this.onClearSelection,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isSelectionMode) {
      return AppBar(
        backgroundColor: theme.cardColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClearSelection,
        ),
        title: Text(context.tr.selectedCount(selectedCount),
            style: theme.textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: onDelete,
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,
            size: 20.sp, color: theme.iconTheme.color),
        onPressed: () => sl<NavigationService>().goBack(),
      ),
      title: Row(
        children: [
          Hero(
            tag: 'avatar_$conversationId',
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor, width: 1),
                image: (otherUserImage != null && otherUserImage!.isNotEmpty)
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(otherUserImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: theme.cardColor,
              ),
              child: (otherUserImage == null || otherUserImage!.isEmpty)
                  ? Icon(Icons.person, color: Colors.grey, size: 20.sp)
                  : null,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              otherUserName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
          onPressed: () {},
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
