import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/owner_repository.dart';

class RespondBookingUseCase implements UseCase<Unit, RespondBookingParams> {
  final OwnerRepository repository;
  RespondBookingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RespondBookingParams params) async {
    return await repository.respondToBooking(params);
  }
}

class RespondBookingParams {
  final int bookingId;
  final bool accept;

  RespondBookingParams({required this.bookingId, required this.accept});
}
