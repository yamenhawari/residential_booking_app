import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeartWidget extends StatefulWidget {
  const HeartWidget({super.key});

  @override
  State<HeartWidget> createState() => _FavorItemState();
}

class _FavorItemState extends State<HeartWidget> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : theme.iconTheme.color,
          size: 24.sp,
        ),
      ),
    );
  }
}
