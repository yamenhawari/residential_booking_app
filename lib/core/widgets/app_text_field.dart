import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.prefix,
    this.suffixIcon,
    this.onSuffixTap,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefix,
            suffixIcon: _buildSuffixIcon(theme),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: theme.textTheme.bodyMedium?.color,
        ),
        onPressed: _toggleVisibility,
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: theme.textTheme.bodyMedium?.color),
        onPressed: widget.onSuffixTap,
      );
    }
    return null;
  }
}
