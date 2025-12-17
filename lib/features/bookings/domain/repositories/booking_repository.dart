import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/add_review_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:residential_booking_app/features/bookings/domain/usecases/modify_booking_usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, Unit>> createBooking(CreateBookingParams params);

  Future<Either<Failure, List<Booking>>> getMyBookings();

  Future<Either<Failure, Unit>> cancelBooking(int bookingId);

  Future<Either<Failure, Unit>> modifyBooking(ModifyBookingParams params);
  Future<Either<Failure, Unit>> addReview(ReviewParams params);
}
