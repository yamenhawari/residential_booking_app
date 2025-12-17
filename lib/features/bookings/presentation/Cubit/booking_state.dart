import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

// --- STATES FOR THE LIST (History Page) ---
class GetBookingsLoading extends BookingState {}

class GetBookingsSuccess extends BookingState {
  final List<Booking> bookings;
  const GetBookingsSuccess(this.bookings);
  @override
  List<Object> get props => [bookings];
}

class GetBookingsFailure extends BookingState {
  final String message;
  const GetBookingsFailure(this.message);
  @override
  List<Object> get props => [message];
}

// --- STATES FOR ACTIONS (Create/Cancel/Modify Buttons) ---
class BookingActionLoading extends BookingState {}

class BookingActionSuccess extends BookingState {
  final String message;
  const BookingActionSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class BookingActionFailure extends BookingState {
  final String message;
  const BookingActionFailure(this.message);
  @override
  List<Object> get props => [message];
}
