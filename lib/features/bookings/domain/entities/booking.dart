import 'package:equatable/equatable.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/enums/booking_enum.dart';

class Booking extends Equatable {
  final int id;
  final int apartmentId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.apartmentId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, apartmentId, startDate, endDate, status];
}
