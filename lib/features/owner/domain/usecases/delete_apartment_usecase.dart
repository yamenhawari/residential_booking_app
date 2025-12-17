import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/owner_repository.dart';

class DeleteApartmentUseCase implements UseCase<Unit, int> {
  final OwnerRepository repository;
  DeleteApartmentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int apartmentId) async {
    return await repository.deleteApartment(apartmentId);
  }
}
