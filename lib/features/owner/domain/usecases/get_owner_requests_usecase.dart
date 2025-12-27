import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/bookings/domain/entities/booking.dart';
import '../repositories/owner_repository.dart';

class GetOwnerRequestsUseCase implements UseCase<List<Booking>, NoParams> {
  final OwnerRepository repository;
  GetOwnerRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Booking>>> call(NoParams params) async {
    return await repository.getOwnerRequests();
  }
}
