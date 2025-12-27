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
  final String? apartmentName;
  final String? apartmentImageUrl;
  final String? tenantName;
  final String? tenantImageUrl;
  final double? myRating;

  const Booking({
    required this.id,
    required this.apartmentId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.apartmentName,
    this.apartmentImageUrl,
    this.tenantName,
    this.tenantImageUrl,
    this.myRating,
  });

  @override
  List<Object?> get props => [
        id,
        apartmentId,
        startDate,
        endDate,
        status,
        apartmentName,
        apartmentImageUrl,
        tenantName,
        tenantImageUrl,
        myRating,
      ];
}
