import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class ModifyBookingUseCase implements UseCase<Unit, ModifyBookingParams> {
  final BookingRepository repository;

  ModifyBookingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ModifyBookingParams params) async {
    return await repository.modifyBooking(params);
  }
}

class ModifyBookingParams {
  final int bookingId;
  final DateTime newStartDate;
  final DateTime newEndDate;

  ModifyBookingParams({
    required this.bookingId,
    required this.newStartDate,
    required this.newEndDate,
  });
}
