import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase implements UseCase<Unit, CreateBookingParams> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CreateBookingParams params) async {
    return await repository.createBooking(params);
  }
}

class CreateBookingParams {
  final int apartmentId;
  final DateTime startDate;
  final DateTime endDate;

  CreateBookingParams({
    required this.apartmentId,
    required this.startDate,
    required this.endDate,
  });
}
