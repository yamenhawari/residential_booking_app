import 'package:dartz/dartz.dart';
import 'package:residential_booking_app/features/bookings/domain/entities/booking.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class GetMyBookingsUseCase implements UseCase<List<Booking>, NoParams> {
  final BookingRepository repository;

  GetMyBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Booking>>> call(NoParams params) async {
    return await repository.getMyBookings();
  }
}
