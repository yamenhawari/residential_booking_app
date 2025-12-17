import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';

class CustomCheckBoxWidget extends StatefulWidget {
  final List<String> tabs;

  const CustomCheckBoxWidget(this.tabs, {super.key});

  @override
  State<CustomCheckBoxWidget> createState() => _CustomCheckBoxWidget();
}

class _CustomCheckBoxWidget extends State<CustomCheckBoxWidget> {
  List<int> selectedIndexes = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w, // tighter spacing
      runSpacing: 10,
      children: List.generate(widget.tabs.length, (index) {
        final isSelected = selectedIndexes.contains(index);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedIndexes.remove(index);
              } else {
                selectedIndexes.add(index);
              }
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              // Selected = Primary, Unselected = Light Grey Surface
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.lightGrey,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Text(
              widget.tabs[index].trim(),
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }
}
