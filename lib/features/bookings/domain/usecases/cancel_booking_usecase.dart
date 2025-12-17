import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class CancelBookingUseCase implements UseCase<Unit, int> {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int bookingId) async {
    return await repository.cancelBooking(bookingId);
  }
}
