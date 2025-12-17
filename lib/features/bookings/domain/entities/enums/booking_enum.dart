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
}
