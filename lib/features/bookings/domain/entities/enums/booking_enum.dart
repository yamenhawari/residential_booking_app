import 'package:flutter/material.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';

enum BookingStatus {
  pending,
  confirmed,
  rejected,
  cancelled,
  completed;

  static BookingStatus fromString(String status) {
    try {
      return BookingStatus.values.byName(status.toLowerCase());
    } catch (_) {
      return BookingStatus.pending;
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
      case BookingStatus.rejected:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  String localizedName(BuildContext context) {
    switch (this) {
      case BookingStatus.pending:
        return context.tr.pending;
      case BookingStatus.confirmed:
        return context.tr.confirmed;
      case BookingStatus.cancelled:
        return context.tr.cancelled;
      case BookingStatus.rejected:
        return context.tr.rejected;
      case BookingStatus.completed:
        return context.tr.completed;
    }
  }
}
