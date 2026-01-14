import 'package:flutter/material.dart';

class AppSnackBars {
  static void showSuccess(BuildContext context,
      {required String message, String title = "Success"}) {
    _showSnackBar(context, message, Colors.green, Icons.check_circle_outline);
  }

  static void showInfo(BuildContext context,
      {required String message, String title = "Info"}) {
    _showSnackBar(context, message, Colors.blue, Icons.info_outline);
  }

  static void showError(BuildContext context,
      {required String message, String title = "Error"}) {
    _showSnackBar(context, message, Colors.red, Icons.error_outline);
  }

  static void showWarning(BuildContext context, {required String message}) {
    _showSnackBar(context, message, Colors.orange, Icons.warning_amber_rounded);
  }

  static void _showSnackBar(
      BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
