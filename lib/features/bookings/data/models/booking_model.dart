import '../../domain/entities/booking.dart';
import '../../domain/entities/enums/booking_enum.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.apartmentId,
    required super.startDate,
    required super.endDate,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      apartmentId: json['apartment_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: BookingStatus.fromString(json['status']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apartment_id': apartmentId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'total_price': totalPrice,
      'status': status.name,
    };
  }
}
