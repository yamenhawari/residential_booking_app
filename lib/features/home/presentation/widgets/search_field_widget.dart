import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/features/home/presentation/screens/search_filter_screen.dart';
import 'package:residential_booking_app/110n/app_localizations.dart';

class SearchFieldWidget extends StatefulWidget {
  const SearchFieldWidget({super.key});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: SizedBox(
        height: 50.h,
        child: TextField(
          readOnly: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchFilterScreen(),
              ),
            );
          },
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.cardColor,
            hintText: AppLocalizations.of(context)!.searchHint,
            hintStyle: theme.textTheme.bodyMedium,
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: theme.dividerColor, shape: BoxShape.circle),
              child: Icon(
                Icons.tune,
                color: theme.iconTheme.color,
                size: 20,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
